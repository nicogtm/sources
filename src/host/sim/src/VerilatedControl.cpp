/* Copyright (c) 2016 by the author(s)
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * Author(s):
 *   Stefan Wallentowitz <stefan.wallentowitz@tum.de>
 */

#include "VerilatedControl.h"

#include <verilated_vcd_c.h>

#include <iostream>

void _VL_STRING_TO_VINT(int obits, void* destp, int srclen, const char* srcp);

namespace optimsoc {

void VerilatedControl::init(VerilatedToplevel &top, int argc,
                            char* argv[]) {
    m_top = &top;
    m_time = 0;

    Verilated::commandArgs(argc, argv);

    m_opt= new OptionsParser();
    m_opt->parse(argc, argv);
}

VerilatedControl::~VerilatedControl() {
}

void VerilatedControl::addMemory(const char* scopename) {
    m_Memories.push_back(strdup(scopename));
}

void VerilatedControl::setMemoryFuncs(readmemh_func readmemh,
                                      readmemh_file_func readmemh_file) {
    m_readmemh = readmemh;
    m_readmemh_file = readmemh_file;
}

uint64_t VerilatedControl::getTime() {
    return m_time;
}

void VerilatedControl::run() {
    svScope scope;

    for (std::vector<const char*>::iterator it = m_Memories.begin();
            it != m_Memories.end(); ++it) {
        scope = svGetScopeFromName (*it);
        assert(scope);
        svSetScope (scope);

        if (m_opt->hasMemInit()) {
            const char *filename = m_opt->getMemInit();
            unsigned int filename_vl[16];
            _VL_STRING_TO_VINT(16*sizeof(unsigned int)*8, filename_vl, strlen(filename), filename);
            m_readmemh_file(filename_vl);
        } else {
            m_readmemh();
        }
    }

    VerilatedVcdC vcd;

    bool isvcd = m_opt->isVcd();
    uint64_t vcdfrom = m_opt->getVcdFrom();
    uint64_t vcdto = m_opt->getVcdTo();

    if (isvcd) {
        Verilated::traceEverOn(true);

        m_top->wrapTrace(&vcd, 99, 0);
        vcd.open("sim.vcd");
    }

    m_top->sig_clk.set(0);
    m_top->sig_rst_cpu.set(1);
    m_top->sig_rst_sys.set(1);

    uint64_t limit = m_opt->getLimit();

    while (true) {
        if ((limit > 0) && (m_time > limit)) {
            break;
        }

        if (m_time == 4) {
            m_top->sig_rst_cpu.set(0);
            m_top->sig_rst_sys.set(0);
        }

        m_top->sig_clk.set(1 - m_top->sig_clk.get());
        m_top->wrapEval();

        if (isvcd && (m_time > vcdfrom) &&
                ((vcdto == 0) || (m_time < vcdto))) {
            vcd.dump(m_time);
        }

        if (Verilated::gotFinish()) {
            break;
        }

        m_time++;
    }
}

}

double sc_time_stamp() {
    return optimsoc::VerilatedControl::instance().getTime();
}


