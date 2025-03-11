using DelimitedFiles, Interpolations, DSP, Statistics, Plots

# %% Import data
z = readdlm("data/CENOGRID_Loess_20.txt")

# %% Interpolate to uniform time scale
dt = 0.005
t = z[1,1]:dt:z[end,1]

# Interpolation using Piecewise Cubic Hermite Interpolating Polynomial (PCHIP)
interp_func = interpolate((z[:,1],), z[:,2:3], Gridded(Linear()))
y = hcat([interp_func(t[i]) for i in 1:length(t)]...)

y = mapslices(zscore, y, dims=1) # Standardize data (Z-score normalization)

# %% Low-pass filter the data
fs = 1 / dt  # Sampling frequency
cutoff_freq = 0.001 # High-pass filter cutoff (0.2 cycles per Ma)
b, a = butter(5, cutoff_freq, Highpass(fs=fs)) 
x = filtfilt(b, a, y, dims=1) # Apply filter to each column

# %% Get windowed results
w = round(Int, 1 / dt)  # 1000 ky windows
ws = round(Int, 0.25 / dt)  # Window step 250 ky
proxy = ["δ¹³C", "δ¹⁸O"]

# Placeholder function for RQA determinism (implement properly based on package availability)
function determinism(data, m, τ, threshold, w, ws)
    # This function should compute determinism in moving windows
    # Replace with appropriate RQA library or custom implementation
    rq = rand(length(1:ws:length(data))) # Random placeholder
    rq_quant = [minimum(rq), quantile(rq, 0.95)] # Confidence interval estimate
    return rq, rq_quant
end

# %% Plot results
plot()
for param in 1:2
    # Compute determinism in moving windows
    rq, rq_quant = determinism(x[:,param], 1, 1, 0.1, w, ws)

    t2 = dt * w / 2 .+ t[1:ws:end]
    t2 = t2[1:length(rq)]  # Adjust length

    # Plot determinism
    plot!(t2, rq, lw=2, label=proxy[param])
    hline!([rq_quant[2]], linestyle=:dash, color=:red, label="95% CI")

    xlabel!("Age (Ma)")
    ylabel!("DET")
    title!(proxy[param])
    xflip!() # Reverse x-axis (Ma → Present)
    grid!(true)
    display(plot())
end
