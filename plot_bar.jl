@info "LOADING PACKAGE..."
using DataFrames
using CSV
using Plots
using Images
using StatsPlots

key = "head"

folder_path = joinpath(@__DIR__, "export", key)
data_480_640 = CSV.read(joinpath(folder_path, "export_data.csv"), DataFrame)

sdm_data = filter(x->x.Method == "sdm_data_zoom" || x.Method == "rse_data_zoom", data_480_640)
# rse_data = filter(x->x.Method == "rse_data_zoom", data_480_640)

sx = repeat(["SDM", "RSE"], inner = 3)
nam = repeat(["480×640", "360×480", "240×320"], outer = 2)

p_ENL = groupedbar(sdm_data.ENL, group = sx, ylabel = "ENL", title = "ENL", bar_width = 0.67, lw = 0, framestyle = :box)
p_SSI = groupedbar(sdm_data.SSI, group = sx, ylabel = "ENL", title = "ENL", bar_width = 0.67, lw = 0, framestyle = :box, tex_output_standalone = true)
p_SMPI = groupedbar(sdm_data.SMPI, group = sx, ylabel = "ENL", title = "ENL", bar_width = 0.67, lw = 0, framestyle = :box, tex_output_standalone = true)

plot(p_ENL, p_SSI, p_SMPI, layout(3, 1), size=(300, 800))

saving_path = joinpath(@__DIR__, "Plot")
savefig(plot_ENL, joinpath(saving_path, "Bar_ENL_$key.tex"))

std_men = [2, 3, 4, 1, 2]
std_women = [3, 5, 2, 3, 3]

bar(
  ["G1", "G2", "G3"],
  [20, 35, 30],
  fillcolor=[:red,:green,:blue],
  fillalpha=[0.2,0.4,0.6])
)

bar!(
  ["G1", "G2", "G3"],
  [30, 45, 50],
  fillcolor=[:red,:green,:blue],
  fillalpha=[0.2,0.4,0.6]
)
mn = [20, 35, 30, 35, 27,25]
sx = repeat(["SDM", "RSE"], inner = 3)
std = [2, 3, 4, 1, 2, 3]
nam = repeat("G" .* string.(1:5), outer = 2)
nam = repeat(["480×640", "360×480", "240×320"], outer = 2)

using StatsPlots
groupedbar(nam, mn, group = sx, ylabel = "Scores", title = "ENL")


ctg = repeat(["Category 1", "Category 2"], inner = 5)
nam = repeat("G" .* string.(1:5), outer = 2)

groupedbar(nam, rand(5, 2), group = ctg, xlabel = "Groups", ylabel = "Scores",
        title = "Scores by group and category", bar_width = 0.67,
        lw = 0, framestyle = :box)