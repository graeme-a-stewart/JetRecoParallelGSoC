
# visualize dpms and time taken to run parallel-euclid vs active thread count
# Author: Somnath Karmakar <somnathkarmakar1203@gmail.com>

using Plots

# the X-axis: number of threads (1 through 12)
threads = 1:12

# the Y-axis (Seconds): each column represents one of the 4 trials
seconds = [
    0.4873  0.4885  0.4893  0.5050
    0.3589  0.3644  0.3585  0.3606
    0.2760  0.2752  0.2761  0.2811
    0.2187  0.2289  0.2236  0.2236
    0.1881  0.1965  0.1940  0.2010
    0.1655  0.1677  0.1648  0.1694
    0.1454  0.1525  0.1571  0.1561
    0.1365  0.1350  0.1407  0.1431
    0.1397  0.1407  0.1373  0.1309
    0.1311  0.1417  0.1312  0.1426
    0.1292  0.1350  0.1477  0.1316
    0.1335  0.1284  0.1385  0.1290
]

# The Y-axis (DM/s): Each column represents one of the 4 trials
dmps = [
    205.22  204.72  204.39  198.01
    278.59  274.40  278.96  277.34
    362.38  363.41  362.16  355.78
    457.25  436.79  447.17  447.25
    531.73  508.82  515.55  497.59
    604.14  596.21  606.96  590.36
    687.63  655.91  636.60  640.46
    732.36  740.67  710.92  698.72
    715.81  710.79  728.52  763.83
    762.68  705.49  762.04  701.13
    774.16  740.96  677.04  759.68
    748.92  779.01  721.90  774.93
]

# labels for the legend (1x4 matrix maps to the 4 columns of the run data)
trial_labels = ["Trial 1" "Trial 2" "Trial 3" "Trial 4"]

println("Generating plot for Execution Time (Seconds) vs Threads...")
plot1 = plot(threads, seconds, 
    title = "Execution Time vs Thread Count",
    xlabel = "Number of Threads",
    ylabel = "Execution Time (Seconds)",
    labels = trial_labels,
    marker = :circle,       # adds dots at data points
    linewidth = 2,
    xticks = 1:12,          # forces X-axis to show every integer
    alpha = 0.8             # transparency so overlapping lines are visible
)

# save the first plot
savefig(plot1, "time_vs_threads.png")
println("Saved 'time_vs_threads.png'")


println("Generating plot for Throughput (DM/s) vs Threads...")
plot2 = plot(threads, dmps, 
    title = "Throughput (DM/s) vs Thread Count",
    xlabel = "Number of Threads",
    ylabel = "Distance Measures / Second (Millions)",
    labels = trial_labels,
    marker = :diamond,
    linewidth = 2,
    xticks = 1:12,
    legend = :topleft,
    alpha = 0.8
)

# save the second plot
savefig(plot2, "dmps_vs_threads.png")
println("Saved 'dmps_vs_threads.png'")
