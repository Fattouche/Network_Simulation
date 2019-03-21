//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
// 
// You should have received a copy of the GNU Lesser General Public License
// along with this program.  If not, see http://www.gnu.org/licenses/.
// 

package inet.Network_Simulation.routers;
import inet.common.queue.FifoQueue;
import inet.common.queue.IOutputQueue;
import inet.common.queue.RedDropper;
import inet.node.inet.Router;
import ned.IdealChannel;


module REDQueue like IOutputQueue
{
    gates:
        input in;
        output out;

    submodules:
        red: RedDropper {
            numGates = 1;
            wq = default(0.002);
            minths = default("30");
            maxths = default("90");
            maxps = default("0.10");
            pkrates = default("8333.333");
        }
        fifo: FifoQueue;
    connections:
        in --> red.in[0];
        red.out[0] --> fifo.in++;
        fifo.out --> out;
}

module RedRouter extends Router
{
    submodules:
    connections:
}

