#!/bin/bash
#
# this script runs parallel-benchmark.jl for each thread count
# Author: Somnath Karmakar <somnathkarmakar1203@gmail.com>

# store the total number logical cores
THREADS=$(nproc)

# run the benchmark for each number of active cores at a time
for t in $(seq 1 $THREADS); do
    julia -t $t parallel-benchmark.jl
done
