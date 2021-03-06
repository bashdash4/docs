# Breadth-First Search (BFS)
A fundamental graph search algorithm that, as the name suggests, searches through the vertices of an unweighted graph in the order of shortest to longest distance from a given source vertex and typically also returns an array of the edge distances (least number of edges) from the source vertex to every other vertex. It does this by using adjacency lists to discover new vertices, starting with the source vertex and going by order of discovery, and assigning distances based on number of edges from the source vertex. One of the fastest search algorithms and a building block with which other graph algorithms and applications are built.


## Summary of Results
[IN PROGRESS]

## Summary of Gunrock Implementation
Conceptually, this implementation isn’t extremely different from a standard serial implementation, but running searches and checking vertices concurrently through parallelism improves the potential for efficiency. Gunrock completes BFS with a series of “Advance” and “Filter” steps.

In the Advance step, we search the vertices in our search frontier in parallel and create a new frontier from vertices adjacent to those searched. At this point, we classify newly discovered vertices as such and classify already discovered vertices as "invalid" in the new frontier.

In the Filter step, we check this new frontier's vertices in parallel and filter out the invalid vertices (those that would be redundant to search). We then use the frontier remaining from this operation for the next search iteration.

Gunrock BFS features a setting for idempotence optimization, which typically improves performance despite the chance that we may visit vertices (and hence edges) more than once. It also supports direction-optimization, able to choose between both push/pull (top-down/bottom-up) operations at each step, improving performance further.

Whereas push is textbook BFS, where discovered vertices look for their undiscovered children for the next search iteration, pull is the opposite; undiscovered children look for their parents to search next. Both yield valid results at each step, but each has scenarios in which they are more optimal than the other.

Pseudocode:
```
function BFS (Graph, source):
	//RESET
	for each vertex v in Graph:
		discovered[v] = 0
	discovered[source] = 1 	//Source vertex is discovered by default
	Q0 = {source}		//Search queue, starts with only source vertex in it
	//ADVANCE
	while Q0 is not empty:
		Q1 = {}		//Temp queue
		for each v in Q0, do in parallel:
			for each edge e<u,v> of v, do in parallel:
 				if (discovered[u] == 0)
					discovered[u] = 1
					put u in Q1
				else
					put invalid in Q1
	//FILTER (at this point Q0 should be empty)
	for each u in Q1, do in parallel:
		if (u is valid):
			put u in Q0
```

## How to Run This Application on DARPA's DGX-1
### Prereqs/Input
 - Ensure that CUDA is installed and configured properly
 - [Build Gunrock](https://gunrock.github.io/docs/#quick-start-guide). All requisite files should be in the necessary directories.
 - Go into examples/bfs and make
Command line might look something like this:
```
git clone --recursive https://github.com/gunrock/gunrock/
cd gunrock
mkdir build && cd build
cmake .. && make -j$(nproc)
cd ../examples/bfs
make clean
make
```

### Running the Application
#### Arguments
```
Required arguments:
--graph-type : std::string, default =
graph type, be one of market, rgg, rmat, grmat or smallworld


Optional arguments:
--64bit-SizeT : std::vector<bool>, default = 0
Whether to use 64-bit SizeT

--64bit-ValueT : std::vector<bool>, default = 0
Whether to use 64-bit ValueT

--64bit-VertexT : std::vector<bool>, default = 0
Whether to use 64-bit VertexT

--advance-mode : std::vector<std::string>, default = LB
Advance strategy, <LB | LB_CULL | LB_LIGHT | LB_LIGHT_CULL | TWC>,
default is determined based on input graph

--binary-prefix : std::string, default =
Prefix to store a binary copy of the graph, default is the value of -graph-file

--communicate-latency : int, default = 0
additional communication latency

--communicate-multipy : float, default = 1
communication sizing factor

--dataset : std::string, default =
Name of dataset, default value is set by graph reader / generator

--device : std::vector<int>, default = 0
Set GPU(s) for testing

--direction-optimized : std::vector<bool>, default = 0
Whether to enable direction optimizing BFS

--do-a : std::vector<float>, default = 0.001
Threshold to switch from forward-push to backward-pull in DOBFS

--do-b : std::vector<float>, default = 0.2
Threshold to switch from backward-pull to forward-push in DOBFS

--edge-value-min : float, default = 0
Minimum value of edge values when randomly generated

--edge-value-range : float, default = 64
Range of edge values when randomly generated

--edge-value-seed : long, default = 0
Rand seed to generate edge values, default is time(NULL)

--expand-latency : int, default = 0
additional expand incoming latency

--filter-mode : std::string, default = CULL
Filter strategy

--fullqueue-latency : int, default = 0
additional fullqueue latency

--graph-edgefactor : double, default = 48
Edge factor

--graph-edges : long long, default = 49152
Number of edges

--graph-file : std::string, default =
graph file, empty points to STDIN

--graph-nodes : long long, default = 1024
Number of nodes

--graph-scale : long long, default = 10
Vertex scale

--graph-seed : int, default = 0
Rand seed to generate the graph, default is time(NULL)

--grmat : bool, default = false
Generate rmat using GPU

--help : bool, default = false
Print this usage.

--idempotence : std::vector<bool>, default = 0
Whether to enable idempotence optimization

--json : bool, default = false
Whether to output statistics in json format

--jsondir : std::string, default =
Directory to output statistics in json format

--jsonfile : std::string, default =
Filename to output statistics in json format

--makeout-latency : int, default = 0
additional make-out latency

--mark-pred : std::vector<bool>, default = 0
Whether to mark predecessor info.

--max-grid-size : int, default = 0
Maximun number of grids for GPU kernels

--num-runs : int, default = 1
Number of runs to perform the test, per parameter-set

--partition-factor : float, default = 0.5
partitioning factor

--partition-method : std::string, default = random
partitioning method, can be one of {random, biasrandom, cluster, metis, static, duplicate}

--partition-seed : int, default = 0
partitioning seed, default is time(NULL)

--queue-factor : std::vector<double>, default = 6
Reserved frontier sizing factor, multiples of numbers of vertices or edges

--quick : bool, default = false
Whether to skip the CPU reference validation process.

--quiet : bool, default = false
No output (unless --json is specified).

--random-edge-values : bool, default = false
If true, graph edge values are randomly generated when missing. If false, they are set to 1.

--read-from-binary : bool, default = true
Whether to read a graph from binary file, if supported and file available

--remove-duplicate-edges : bool, default = true
Whether to remove duplicate edges

--remove-self-loops : bool, default = true
Whether to remove self loops

--rgg-thfactor : double, default = 0.55
Threshold-factor

--rgg-threshold : double, default = 0
Threshold, default is thfactor * sqrt(log(#nodes) / #nodes)

--rmat-a : double, default = 0.57
a for rmat generator

--rmat-b : double, default = 0.19
b for rmat generator

--rmat-c : double, default = 0.19
c for rmat generator

--rmat-d : double, default = 0.05
d for rmat generator, default is 1 - a - b - c

--size-check : bool, default = true
Whether to enable frontier auto resizing

--small-world-k : long long, default = 6
k

--small-world-p : double, default = 0
p

--sort-csr : bool, default = false
Whether to sort CSR edges per vertex

--src : std::vector<std::string>, default = 0
<Vertex-ID|random|largestdegree> The source vertices
If random, randomly select non-zero degree vertices;
If largestdegree, select vertices with largest degrees

--src-seed : int, default = -1
seed to generate random sources

--store-to-binary : bool, default = true
Whether to store the graph to binary file, if supported

--subqueue-latency : int, default = 0
additional subqueue latency

--tag : std::vector<std::string>, default =
Tag to better describe and identify json outputs

--trans-factor : double, default = 1
Reserved sizing factor for data communication, multiples of number of vertices

--undirected : std::vector<bool>, default = 0
Whether graph is undirected

--v : bool, default = false
Print verbose per iteration debug info.

--validation : std::string, default = last
<none | last | each> When to validate the results

--vertex-start-from-zero : bool, default = true
Whether the vertex Id in starts from 0 instead of 1
```

#### Example Command Line
```
./bin/test_bfs_10.0_x86_64 --graph-type market --graph-file ../../dataset/small/chesapeake.mtx
```

#### Sample Input
The graphs are represented as the list of its edges, in numerical order (based on the vertex with the lowest number), not repeating. For **chesapeake.mtx**, for example, here is how it represents the edges connected to vertex 1:
```
7 1
8 1
11 1
12 1
13 1
22 1
23 1
34 1
35 1
37 1
39 1
```

#### Sample Output
```
Loading Matrix-market coordinate-formatted graph ...
  Reading meta data from ../../dataset/small/chesapeake.mtx.meta
  Reading edge lists from ../../dataset/small/chesapeake.mtx.coo_edge_pairs
Reading from ../../dataset/small/chesapeake.mtx.coo_edge_pairs, typeId = 262, targetId = 262, length = 170
  Substracting 1 from node Ids...
  Edge doubleing: 170 -> 340 edges
  graph loaded as COO in 0.004628s.
Converting 39 vertices, 340 directed edges ( ordered tuples) to CSR format...Done (0s).
Converting 39 vertices, 340 directed edges (unordered tuples) to CSC format...Done (0s).
Degree Histogram (39 vertices, 340 edges):
    Degree 0: 0 (0.000000 %)
    Degree 2^0: 0 (0.000000 %)
    Degree 2^1: 1 (2.564103 %)
    Degree 2^2: 22 (56.410256 %)
    Degree 2^3: 13 (33.333333 %)
    Degree 2^4: 2 (5.128205 %)
    Degree 2^5: 1 (2.564103 %)

Computing reference value ...
__________________________
--------------------------
Run 0 elapsed: 0.007868 ms, src = 0, #iterations = 3
==============================================
64bit-VertexT=false 64bit-SizeT=false 64bit-ValueT=false undirected=false mark-pred=0 advance-mode=LB direction-optimized=0 do-a=0.001 do-b=0.2 idempotence=0
Using advance mode LB
Using filter mode CULL
__________________________
--------------------------
Run 0 elapsed: 0.288963 ms, src = 0, #iterations = 3
Label Validity: PASS
First 40 labels of the GPU result:
[0:0 1:2 2:2 3:2 4:2 5:2 6:1 7:1 8:2 9:2 10:1 11:1 12:1 13:2 14:2 15:2 16:2 17:2 18:2 19:2 20:2 21:1 22:1 23:2 24:2 25:2 26:2 27:2 28:2 29:2 30:2 31:2 32:2 33:1 34:1 35:2 36:1 37:2 38:1 ]
First 40 distances of the reference CPU result.
[0:0 1:2 2:2 3:2 4:2 5:2 6:1 7:1 8:2 9:2 10:1 11:1 12:1 13:2 14:2 15:2 16:2 17:2 18:2 19:2 20:2 21:1 22:1 23:2 24:2 25:2 26:2 27:2 28:2 29:2 30:2 31:2 32:2 33:1 34:1 35:2 36:1 37:2 38:1 ]

[bfs] finished.
 avg. elapsed: 0.288963 ms
 iterations: 3
 min. elapsed: 0.288963 ms
 max. elapsed: 0.288963 ms
 rate: 1.176620 MiEdges/s
 src: 0
 nodes_visited: 39
 edges_visited: 340
 nodes queued: 39
 load time: 4.95505 ms
 preprocess time: 334.938000 ms
 postprocess time: 0.324965 ms
 total time: 335.676908 ms
```

### Output
Output is text that explains steps taken, shows passes through graph, displays distances, and displays runtime statistics and other diagnostic information such as number of iterations and vertices/edges visited. Comparisons to proven implementations of BFS can be used for correctness checking.

## Performance and Analysis
Performance is measured in total runtime, given:
- An input graph ```G = (V, E)```
- A specified source vertex
- Whether or not idempotence is enabled
- Whether or not direction-optimization is enabled

GPU used: NVIDIA Tesla V100

Runtimes are in milliseconds unless stated otherwise

Results are the average of ten iterations

Source vertex is always 0

I = idempotence? D = direction-optimized?

| Dataset        | Vertices | Directed Edges | Iterations | GPU, D = 0, I = 0 | CPU, D = 0, I = 0 | GPU, D = 0, I = 1 | CPU, D = 0, I = 1 | GPU, D = 1, I = 0 | CPU, D = 1, I = 0 | GPU, D = 1, I = 1 | CPU, D = 1, I = 1 |
|----------------|----------|----------------|------------|-------------------|-------------------|-------------------|-------------------|-------------------|-------------------|-------------------|-------------------|
| hollywood-2009 | 1139905  | 112751422      | 11         | 8.922029          | 286.689710        | 8.956361          | 287.712173        | 1.598024          | 286.896106        | 1.583290          | 291.364148        |
| indochina-2004 | 7414866  | 191606827      | 4          | 0.375938          | 0.004077          | 0.370169          | 0.004339          | 0.368214          | 0.004506          | 0.368095          | 0.004482          |
| kron_g500-logn21 | 2097152 | 182081864     | 6          | 35.786724         | 866.759107        | 38.003802         | 859.861829        | 1.144910          | 870.205188        | 1.144481          | 867.066571        |
| roadNet-CA     | 1971281  | 5533214        | 555        | 52.319789         | 80.365134         | 52.267694         | 80.823494         | 52.393079         | 82.207774         | 52.458024         | 82.711913         |
| road_usa       | 23947347 | 57708624       | 6262       | 568.059134        | 1144.766895       | 562.527728        | 1139.928662       | 568.485427        | 1144.757886       | 565.472984        | 1150.200342       |
| soc-LiveJournal1 | 4847571 | 68475391      | 15         | 15.608096         | 609.409778        | 15.4284953        | 603.812500        | 6.281614          | 606.473828        | 6.152344          | 613.763886        |
|                |          |                |            |                   |                   |                   |                   |                   |                   |                   |                   |

### Performance Limitations/Profiler Data

Profiler has been run on processes with idempotence and direction-optimization enabled.

#### From hollywood-2009:

![image](https://drive.google.com/uc?export=view&id=1wPamErpWPs4wjqjVvJjNWgRlIO2_7rRT)
![image](https://drive.google.com/uc?export=view&id=1FBOpy2yI3SK6lkhJiFDRx_Vr3O9rzrDV)
Concerns:
- Low Kernel Concurrency [0 ns / 5.32472 ms = 0%]
- Low Compute Utilization [5.33744 ms / 99.54917 s = 0%]
- Low Global Memory Load Efficiency [kernels accounting for 7.8% of compute have low efficiency (30.1% avg)]
- Low Global Memory Store Efficiency [kernels accounting for 18.2% of compute have low efficiency (25.5% avg)]
- Low Shared Memory Efficiency [kernels accounting for 93.6% of compute have low efficiency (37.1% avg)]
- Low Warp Execution Efficiency [kernels accounting for 3.4% of compute have low efficiency (55.2% avg)]

Rank 100 Kernel analyzed:
```c++
void gunrock::oprtr::LB::RelaxPartitionedEdges2<1u, gunrock::graph::Csr<unsigned int, unsigned int, unsigned int, 256u, 0u, true>, unsigned int, unsigned int, gunrock::app::bfs::BFSIterationLoop<gunrock::app::bfs::Enactor<gunrock::app::bfs::Problem<gunrock::app::TestGraph<unsigned int, unsigned int, unsigned int, 768u, 0u>, unsigned int, unsigned int, 0u>, 0u, 0u> >::Core(int)::{lambda(unsigned int const&, unsigned int&, unsigned int const&, unsigned int const&, unsigned int const&, unsigned int&)#1}>(bool, gunrock::graph::Csr<unsigned int, unsigned int, unsigned int, 256u, 0u, true>::VertexT, gunrock::app::bfs::BFSIterationLoop<gunrock::app::bfs::Enactor<gunrock::app::bfs::Problem<gunrock::app::TestGraph<unsigned int, unsigned int, unsigned int, 768u, 0u>, unsigned int, unsigned int, 0u>, 0u, 0u> >::Core(int)::{lambda(unsigned int const&, unsigned int&, unsigned int const&, unsigned int const&, unsigned int const&, unsigned int&)#1}, unsigned int const*, gunrock::app::bfs::BFSIterationLoop<gunrock::app::bfs::Enactor<gunrock::app::bfs::Problem<gunrock::app::TestGraph<unsigned int, unsigned int, unsigned int, 768u, 0u>, unsigned int, unsigned int, 0u>, 0u, 0u> >::Core(int)::{lambda(unsigned int const&, unsigned int&, unsigned int const&, unsigned int const&, unsigned int const&, unsigned int&)#1}::SizeT, unsigned int const* const*, unsigned int const* const, unsigned int*, gunrock::app::bfs::BFSIterationLoop<gunrock::app::bfs::Enactor<gunrock::app::bfs::Problem<gunrock::app::TestGraph<unsigned int, unsigned int, unsigned int, 768u, 0u>, unsigned int, unsigned int, 0u>, 0u, 0u> >::Core(int)::{lambda(unsigned int const&, unsigned int&, unsigned int const&, unsigned int const&, unsigned int const&, unsigned int&)#1}::ValueT*, unsigned int const**, gunrock::util::CtaWorkProgress<unsigned int const*>, gunrock::app::bfs::BFSIterationLoop<gunrock::app::bfs::Enactor<gunrock::app::bfs::Problem<gunrock::app::TestGraph<unsigned int, unsigned int, unsigned int, 768u, 0u>, unsigned int, unsigned int, 0u>, 0u, 0u> >::Core(int)::{lambda(unsigned int const&, unsigned int&, unsigned int const&, unsigned int const&, unsigned int const&, unsigned int&)#1})
```
[Kernel Analysis](https://drive.google.com/open?id=10jB5iJegVfTulTGSQvqF4KcbKX7AsCxm)

![image](https://drive.google.com/uc?export=view&id=1t0BZbOxnYvgL6M1odzM-qffKtFE7OIL6)
![image](https://drive.google.com/uc?export=view&id=1V5nqDqcKD8nIkEEHS38CodpfyS5G_wbZ)

#### From soc-LiveJournal1:
![image](https://drive.google.com/uc?export=view&id=1qv42mDONbJrhr1PeX6Iefxsj-vI46feZ)
![image](https://drive.google.com/uc?export=view&id=1HC_iyYaOTZXjit57yOnAmP1L58gAjLHD)

Concerns:
- Low Compute Utilization [5.20939 ms / 111.53615 s = 0%]
- Low Multiprocessor Occupancy [21.5% avg, for kernels accounting or 96.8% of compute]
- Low Global Memory Load Efficiency [kernels accounting for 95% of compute have low efficiency (29.5% avg)]
- Low Global Memory Store Efficiency [kernels accounting for 92.5% of compute have low efficiency (31.8% avg)]
- Low Shared Memory Efficiency [kernels accounting for 95.5% of compute have low efficiency (19.3% avg)]
- Low Warp Execution Efficiency [kernels accounting for 93% of compute have low efficiency (53.1% avg)]

Rank 100 Kernel analyzed:
```c++
void gunrock::app::bfs::Inverse_Expand<gunrock::app::bfs::Problem<gunrock::app::TestGraph<unsigned int, unsigned int, unsigned int, unsigned int=768, unsigned int=0>, unsigned int, unsigned int, unsigned int=0>, int=9>(unsigned intGraphT, gunrock::app::bfs::Inverse_Expand<gunrock::app::bfs::Problem<gunrock::app::TestGraph<unsigned int, unsigned int, unsigned int, unsigned int=768, unsigned int=0>::SizeT, unsigned int, unsigned int, unsigned int=0>, int=9>, gunrock::app::bfs::Inverse_Expand<gunrock::app::bfs::Problem<gunrock::app::TestGraph<unsigned int, unsigned int, unsigned int, unsigned int=768, unsigned int=0>::VertexT, unsigned int, unsigned int, unsigned int=0>, int=9>
```
[Kernel Analysis](https://drive.google.com/open?id=1z82TxWZBYeJufQ22Y6NltSFqOZwxYPBT)

![image](https://drive.google.com/uc?export=view&id=10XhMcFy_Im0fFu-BatWQcbqOtcZ6_1_9)
![image](https://drive.google.com/uc?export=view&id=106DKg9XKo010jGUgIvWv2x9VVd30DNRF)
![image](https://drive.google.com/uc?export=view&id=1mjphtz1WrhySnsKe1-X2qklx_hEfulAe)

## Next Steps
[IN PROGRESS]
