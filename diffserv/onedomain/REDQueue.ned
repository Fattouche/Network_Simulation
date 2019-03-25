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

package inet.Network_Simulation.diffserv.onedomain;

import inet.common.queue.FifoQueue;
import inet.common.queue.IOutputQueue;
import inet.common.queue.RedDropper;
import inet.node.inet.Router;
import ned.IdealChannel;
import inet.common.queue.PriorityScheduler;
import inet.common.queue.WrrScheduler;
import inet.networklayer.diffserv.BehaviorAggregateClassifier;
import inet.common.queue.DropTailQueue;


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

module NetworkSimulatorQueue like IOutputQueue
{
    gates:
        input in;
        output out;

    submodules:
        classifier: BehaviorAggregateClassifier {
            dscps = "EF AF11 AF21 AF31 AF41";
            @display("p=100,350");
        }
        efQueue: DropTailQueue {
            @display("p=250,100");
        }
        af1xQueue: REDQueue {
            @display("p=250,200");
        }
        af2xQueue: REDQueue {
            @display("p=250,300");
        }
        af3xQueue: REDQueue {
            @display("p=250,400");
        }
        af4xQueue: REDQueue {
            @display("p=250,500");
        }
        beQueue: DropTailQueue {
            @display("p=250,600");
        }
        wrr: WrrScheduler {
            @display("p=400,350");
        }
        priority: PriorityScheduler {
            @display("p=550,350");
        }

    connections:
        in --> classifier.in;
        classifier.outs++ --> efQueue.in;
        classifier.outs++ --> af1xQueue.in;
        classifier.outs++ --> af2xQueue.in;
        classifier.outs++ --> af3xQueue.in;
        classifier.outs++ --> af4xQueue.in;
        classifier.defaultOut --> beQueue.in;

        af1xQueue.out --> wrr.in++;
        af2xQueue.out --> wrr.in++;
        af3xQueue.out --> wrr.in++;
        af4xQueue.out --> wrr.in++;
        beQueue.out --> wrr.in++;
        efQueue.out --> priority.in++;
        wrr.out --> priority.in++;
        priority.out --> out;
}
