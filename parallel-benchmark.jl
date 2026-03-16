
# benchmarking script for parallel-euclid per active threads
# Author: Somnath Karmakar <somnathkarmakar1203@gmail.com>

using BenchmarkTools
using Random
using Base.Threads
Random.seed!(42)

include("parallel-euclid.jl")

n = 10_000
points = rand(Float32, (n, 3)) 

# rarm-up run
pairwise_distances_parallel(points)

total_measures = n^2 

# run the benchmark
threads = nthreads()

# @belapsed returns minimum time in seconds
elapsed_sec = @belapsed pairwise_distances_parallel($points)

# calculate DM/s and convert to Millions for readability
dm_per_sec = total_measures / elapsed_sec
million_dm_per_sec = dm_per_sec / 1_000_000

# print in a CSV-friendly format
# THREADS, ROUNDED ELAPSED SECONDS, MDPS
println("$threads, $(round(elapsed_sec, digits=4)), $(round(million_dm_per_sec, digits=2))")
