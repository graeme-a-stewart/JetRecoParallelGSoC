
# Obvious improvements to the baseline code
# Author: Somnath Karmakar <sommnathkarmakar1203@gmail.com>

"""
Changes:
- replace size(points)[i] with size(points, i) -> remove tuple allocation overhead
- avoid duplicate distance calculations
- remove bounds checking in loops
"""
function pairwise_distances_improved(points::AbstractArray{T}) where T
	@assert size(points, 2) == 3	# get the second dimension directly
	n = size(points, 1)				# get the first dimension directly
	distances = zeros(T, (n, n))    # set all cells 0

	# extract the columns first as Julia uses column-major order
	x = points[:,1]
	y = points[:,2]
	z = points[:,3]

	# remove unnecessary bounds checking in both loops
	@inbounds begin
	
	    # optimized loop that does not recalculate points (i,j) if already calculated (j,i)
	    for i in 1:n

			# store point i coords to prevent fetching them 10_000 times in the inner loop
			xi = x[i]
			yi = y[i]
			zi = z[i]

		    for j in i+1:n			# no need to calculate points(i,i) - always 0
			    #dx = points[i,1] - points[j,1]
			    #dy = points[i,2] - points[j,2]
			    #dz = points[i,3] - points[j,3]
				dx = xi - x[j]
				dy = yi - y[j]
				dz = zi - z[j]

			    distances[i,j] = sqrt( dx*dx + dy*dy + dz*dz ) # * is faster than ^
			    distances[j,i] = distances[i,j]
		    end
	    end

	end	

	return distances
end

# no mains() function -> main execution will be handled by benchmarking code
