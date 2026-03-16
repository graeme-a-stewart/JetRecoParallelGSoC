
# Benchmarking serial-euclid.jl, improved-serial.jl and parallel-euclid.jl
# Author: Somnath Karmakar <somnathkarmakar1203@gmail.com>

using BenchmarkTools

# set seed for reproducibility
using Random
Random.seed!(42)

# load and execute the implementations once
# first execution triggers JIT compilation - subsequent runs measure only execution time
include("serial-euclid.jl")
include("improved-serial.jl")
include("parallel-euclid.jl")

# generate test data
n = 10_000
points = rand(Float32, (n, 3))

# warm-up runs
pairwise_distances(points)
pairwise_distances_improved(points)
pairwise_distances_parallel(points)

# calculate total distances
total_measures = n^2

# helper function
function benchmark_stats(trial, name, total_measures)
	min_trial = minimum(trial)
	time_sec = min_trial.time / 1e9
	time_ms = time_sec * 1000
	allocs = min_trial.allocs
	mem_mib = min_trial.memory / 1048576	# bytes to MiB

	dmps = (total_measures / time_sec) / 1_000_000	# millions of distances measured per second

	println("\n==== $name ====")
	println("  $(round(time_ms, digits=3)) ms ($allocs allocations: $(round(mem_mib, digits=2)) MiB)")
	println("  Throughput (effective): $(round(dmps, digits=2)) Million DM/s")
end

println("\nBenchmarks:")

# run the benchmarks
b_base = @benchmark pairwise_distances($points)
benchmark_stats(b_base, "BASELINE SERIAL", total_measures)

b_impr = @benchmark pairwise_distances_improved($points)
benchmark_stats(b_impr, "IMPROVED SERIAL", total_measures)

b_para = @benchmark pairwise_distances_parallel($points)
benchmark_stats(b_para, "PARALLEL", total_measures)

