# Breadth-First Search (BFS)
A fundamental graph search algorithm that, as the name suggests, searches through the vertices of an unweighted graph in the order of shortest to longest distance from a given source vertex and typically also returns an array of the edge distances (least number of edges) from the source vertex to every other vertex. It does this by using adjacency lists to discover new vertices, starting with the source vertex and going by order of discovery, and assigning distances based on number of edges from the source vertex. One of the fastest search algorithms and a building block with which other graph algorithms and applications are built.


## Summary of Results
[IN PROGRESS]

## Summary of Gunrock Implementation
[CURRENTLY BEING REVISED]
Conceptually, this implementation isn’t extremely different from a standard serial implementation, but running searches and checking vertices concurrently through parallelism improves the potential for efficiency. With Gunrock, BFS can be completed with a series of “Advance” and “Filter” steps. Recently discovered vertices are searched, with distances from the source vertex updated. From these vertices, a new frontier is formed and placed into a temp queue with all the adjacent edges, which is then filtered to remove already discovered nodes. The vertices that remain are then placed in the search queue.

Pseudocode:
```
function BFS (Graph, source):
	//RESET
	for each vertex v in Graph:
		distance[v] = inf
	distance[source] = 0 	//Distance of source is zero
	Q0 = {source}		//Search queue, starts with only source vertex in it
	//ADVANCE
	while Q0 is not empty:
		Q1 = {}		//Temp queue
		for each v in Q0, do in parallel:
			for each edge e<u,v> of v, do in parallel:
 				if (distance[u] == inf)
					distance[u] = distance[v] + 1
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
[IN PROGRESS]

## Next Steps
[IN PROGRESS]
