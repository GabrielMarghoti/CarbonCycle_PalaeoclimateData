using CSV
using DataFrames
using Plots
using RecurrenceAnalysis

# Define the paths
data_folder = "Kennett-et-al-2017-datasets"
figures_folder = "figures"

# Create the figures folder if it doesn't exist
if !isdir(figures_folder)
    mkpath(figures_folder)
end

# Function to read and plot data
function plot_data(file_path::String, output_folder::String)
    # Read the data
    data = CSV.read(file_path, DataFrame)
    
    # Handle missing values by removing rows with any missing values
    data = dropmissing(data)
    
    # Assuming the first column is the time series data
    time_series = data[:, 2]
    
    # Compute the recurrence plot
    RP = RecurrenceMatrix(time_series, 0.1)  # Adjust parameters as needed
    
    # Plot the recurrence plot
    p = heatmap(RP, title=basename(file_path), xlabel="Time", ylabel="Time",
                c=:grays, colorbar_title="Recurrence", size=(800, 600), dpi=200,
                colorbar=false, frame_style=:box)
    
    # Save the plot
    output_file = joinpath(output_folder, basename(file_path) * "_recurrence_plot.png")
    savefig(p, output_file)
end

# Get the list of data files
data_files = filter(f -> endswith(f, ".csv"), readdir(data_folder, join=true))

# Plot each data file
for file in data_files
    println("Processing file: $file")
    
    plot_data(file, figures_folder)
end