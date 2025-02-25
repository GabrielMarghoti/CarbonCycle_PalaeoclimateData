using CSV
using DataFrames
using Plots

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
    
    # Assuming the first column is the x-axis and the second column is the y-axis
    x_col = names(data)[1]
    y_col = names(data)[2]
    
    # Plot the data
    p = plot(data[:, x_col], data[:, y_col], title=basename(file_path), xlabel=x_col, ylabel=y_col,
            lc=:black, lw=1, label="",
            grid=false, dpi=200, size=(800, 600),
            legend=false, frame_style=:box)
    
    # Save the plot
    output_file = joinpath(output_folder, basename(file_path) * ".png")
    savefig(p, output_file)
end

# Get the list of data files
data_files = filter(f -> endswith(f, ".csv"), readdir(data_folder, join=true))

# Plot each data file
for file in data_files
    println("Processing file: $file")
    
    plot_data(file, figures_folder)
end