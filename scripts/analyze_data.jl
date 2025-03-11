using CSV
using DataFrames
using Plots
using FilePaths

# Define folders
const DATA_FOLDER = "Kennett-et-al-2017-datasets"
const FIGURES_FOLDER = "figures"

# Create the figures folder if it doesn't exist
if !isdir(FIGURES_FOLDER)
    mkpath(FIGURES_FOLDER)
end

function main()
    # Read the data
    d13C = CSV.read(joinpath(DATA_FOLDER, "YOK-I_d13C_v2.csv"), DataFrame)
    d13C_filtered = CSV.read(joinpath(DATA_FOLDER, "YOK-I_d13C_kernelfiltered.csv"), DataFrame)
    d18O = CSV.read(joinpath(DATA_FOLDER, "YOK-I_d18O_v2.csv"), DataFrame)
    d18O_filtered = CSV.read(joinpath(DATA_FOLDER, "YOK-I_d18O_kernelfiltered.csv"), DataFrame)
    
    # Drop missing values
    d13C = dropmissing(d13C)
    d13C_filtered = dropmissing(d13C_filtered)
    d18O = dropmissing(d18O)
    d18O_filtered = dropmissing(d18O_filtered)

    # Extract column names
    x_col = names(d13C)[1]  # Assuming the first column is time/depth
    y_col_d13C = names(d13C)[2]
    y_col_d18O = names(d18O)[2]
    print(names(d13C))
    # Create a two-panel plot
    p1 = plot(d13C[:, 1], d13C[:, 2], label="δ¹³C", lw=1, lc=:red)
    plot!(d13C_filtered[:, 1], d13C_filtered[:, 2], label="Filtered δ¹³C", lw=2, lc=:darkred)
    xlabel!(x_col)
    ylabel!("δ¹³C (‰)")
    title!("δ¹³C Record")

    p2 = plot(d18O[:, 1], d18O[:, 2], label="δ¹⁸O", lw=1, lc=:green)
    plot!(d18O_filtered[:, 1], d18O_filtered[:, 2], label="Filtered δ¹⁸O", lw=2, lc=:darkgreen)
    xlabel!(x_col)
    ylabel!("δ¹⁸O (‰)")
    title!("δ¹⁸O Record")

    # Combine the plots
    p_combined = plot(p1, p2, layout=(2,1), size=(800, 600), dpi=200, frame_style=:box, legend=true)
    
    # Save the plot
    output_file = joinpath(FIGURES_FOLDER, "isotope_records.png")
    savefig(p_combined, output_file)
    println("Plot saved as: ", output_file)
end

main()