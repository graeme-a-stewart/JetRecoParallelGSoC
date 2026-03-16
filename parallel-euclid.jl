
# Optimal Parallel Code
# Author: Somnath Karmakar <somnathkarmakar1203@gmail>

using Base.Threads
using LoopVectorization


"""
- undef memory allocation for fast mem allocation
- get SoA from AoS input
- tiling and flattenning the list for load balancing
- SIMD inner loop using @turbo
"""
function pairwise_distances_parallel(points::AbstractArray{T}; block_size=64) where T
	@assert size(points, 2) == 3
	n = size(points, 1)
	
	# allocating without zero-initializing saves a time
	# won't affect result since we'll be overwriting cells anyways
	distances = Matrix{T}(undef, n, n)	

	# Julia uses column-major order
	# transpose input to 3xN to make it SIMD friendly
	pointsT = collect(points')

	# we will usea default 64x64 blocking/tiling for cache locality of points
	# we will also use a task list to flatten the blocks for
	# proper load balancing (preventing triangular imbalance) during parallel execution
	
	num_blocks = cld(n, block_size)	# number of blocks
	tasks = Tuple{Int, Int}[]	# task list to store blocks with indices
	for bi in 1:num_blocks		# populate task list
		for bj in 1:bi
			push!(tasks, (bi, bj))
		end
	end

	# use Threading over blocks
	Threads.@threads for (bi, bj) in tasks

		# points on rows
		row_start = (bi - 1) * block_size + 1
		row_end = min(bi * block_size, n)

		# points on columns
		col_start = (bj - 1) * block_size + 1
		col_end = min(bj * block_size, n)

		# loop for actual calculation
		for j in col_start:col_end

			# can safely disable bounds checking for improved runtime
			@inbounds bx = pointsT[1,j]
			@inbounds by = pointsT[2,j]
			@inbounds bz = pointsT[3,j]

			# SIMD inner loop using @turbo - more aggressive than @simd
			@turbo for i in row_start:row_end
				dx = pointsT[1,i] - bx
				dy = pointsT[2,i] - by
				dz = pointsT[3,i] - bz

				distances[i,j] = sqrt( dx*dx + dy*dy + dz*dz )
			end
		end
	end

	# now symmetrize the distance matrix
	# loop over columns of the upper triangle to write contiguously
	Threads.@threads for i in 1:n

		# zero the diagonal since the declaration did not zero-initialize the matrix
		@inbounds distances[i,i] = zero(T)

		for j in 1:i-1
			@inbounds distances[j,i] = distances[i,j]
		end
	end

	return distances
end
