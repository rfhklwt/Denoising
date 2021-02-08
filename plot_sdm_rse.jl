@info "LOADING PACKAGE..."
using DataFrames
using CSV
using Plots
using Images

key = "tail"

sdm_folder_path = joinpath(@__DIR__, "Data", key, "SDM")
sdm_data_480_640 = CSV.read(joinpath(sdm_folder_path, "480_640", "sdm_data_zoom.csv"), DataFrame);
sdm_data_360_480 = CSV.read(joinpath(sdm_folder_path, "360_480", "sdm_data_zoom.csv"), DataFrame);
sdm_data_240_320 = CSV.read(joinpath(sdm_folder_path, "240_320", "sdm_data_zoom.csv"), DataFrame);

rse_folder_path = joinpath(@__DIR__, "Data", key, "RSE")
rse_data_480_640 = CSV.read(joinpath(rse_folder_path, "480_640", "rse_data_zoom.csv"), DataFrame);
rse_data_360_480 = CSV.read(joinpath(rse_folder_path, "360_480", "rse_data_zoom.csv"), DataFrame);
rse_data_240_320 = CSV.read(joinpath(rse_folder_path, "240_320", "rse_data_zoom.csv"), DataFrame);

S = sdm_data_480_640.S
# SSI
sdm_ssi = [sdm_data_480_640.ssi sdm_data_360_480.ssi sdm_data_240_320.ssi];
rse_ssi = [rse_data_480_640.ssi rse_data_360_480.ssi rse_data_240_320.ssi];

# SMPI
sdm_smpi = [sdm_data_480_640.smpi sdm_data_360_480.smpi sdm_data_240_320.smpi];
rse_smpi = [rse_data_480_640.smpi rse_data_360_480.smpi rse_data_240_320.smpi];

# ENL
sdm_enl = [sdm_data_480_640.enl sdm_data_360_480.enl sdm_data_240_320.enl];
rse_enl = [rse_data_480_640.enl rse_data_360_480.enl rse_data_240_320.enl];

theme(:ggplot2)
c = palette(:tokyo, 4);
pgfplotsx()

@info "PLOTING ENL"

plot(S, sdm_enl, 
    m = :pentagon, alpha = 0.9,
    xlabel = "S", ylabel = "ENL",
    legend = :none, color = [c[1] c[2] c[3]],
    size = (500, 450), tex_output_standalone = true
    )

p_ENL = plot!(S, rse_enl, 
    m = :c, alpha = 0.9, color = [c[1] c[2] c[3]],
    size = (500, 450), tex_output_standalone = true
    )

if key == "head"
    annotate!((200, sdm_enl[end, 1] + 0.015, Plots.text("480×640 (SDM)", 10, c[1])))
    annotate!((200, rse_enl[end, 1] - 0.017, Plots.text("480×640 (RSE)", 10, c[1])))

    annotate!((200, sdm_enl[end, 2] + 0.012, Plots.text("360×480 (SDM)", 10, c[2])))
    annotate!((200, rse_enl[end, 2] - 0.015, Plots.text("360×480 (RSE)", 10, c[2])))

    annotate!((200, sdm_enl[end, 3] + 0.012, Plots.text("240×320 (SDM)", 10, c[3])))
    annotate!((200, rse_enl[end, 3] - 0.015, Plots.text("240×320 (RSE)", 10, c[3])))
else
    annotate!((200, sdm_enl[end, 1] + 0.014, Plots.text("480×640 (SDM)", 10, c[1])))
    annotate!((200, rse_enl[end, 1] - 0.017, Plots.text("480×640 (RSE)", 10, c[1])))

    annotate!((200, sdm_enl[end, 2] + 0.015, Plots.text("360×480 (SDM)", 10, c[2])))
    annotate!((200, rse_enl[end, 2] - 0.015, Plots.text("360×480 (RSE)", 10, c[2])))

    annotate!((200, sdm_enl[end, 3] + 0.015, Plots.text("240×320 (SDM)", 10, c[3])))
    annotate!((200, rse_enl[end, 3] - 0.017, Plots.text("240×320 (RSE)", 10, c[3])))
end

@info "PLOTING SSI"
plot(S, sdm_ssi, m = :pentagon, alpha = 0.9,
    xlabel = "S", ylabel = "SSI",
    legend = :none, color = [c[1] c[2] c[3]],
    size = (500, 450), tex_output_standalone = true
    )
p_SSI = plot!(S, rse_ssi, 
    m = :c, alpha = 0.9, color = [c[1] c[2] c[3]],
    size = (500, 450), tex_output_standalone = true
    )

if key == "head"
    annotate!((200, sdm_ssi[end, 1] - 0.006, Plots.text("480×640 (SDM)", 10, c[1])))
    annotate!((200, rse_ssi[end, 1] + 0.008, Plots.text("480×640 (RSE)", 10, c[1])))

    annotate!((200, sdm_ssi[end, 2] - 0.006, Plots.text("360×480 (SDM)", 10, c[2])))
    annotate!((200, rse_ssi[end, 2] + 0.006, Plots.text("360×480 (RSE)", 10, c[2])))

    annotate!((200, sdm_ssi[end, 3] - 0.006, Plots.text("240×320 (SDM)", 10, c[3])))
    annotate!((200, rse_ssi[end, 3] + 0.006, Plots.text("240×320 (RSE)", 10, c[3])))
else
    annotate!((200, sdm_ssi[end, 1] - 0.006, Plots.text("480×640 (SDM)", 10, c[1])))
    annotate!((200, rse_ssi[end, 1] + 0.008, Plots.text("480×640 (RSE)", 10, c[1])))

    annotate!((200, sdm_ssi[end, 2] - 0.007, Plots.text("360×480 (SDM)", 10, c[2])))
    annotate!((200, rse_ssi[end, 2] + 0.007, Plots.text("360×480 (RSE)", 10, c[2])))

    annotate!((200, sdm_ssi[end, 3] - 0.006, Plots.text("240×320 (SDM)", 10, c[3])))
    annotate!((200, rse_ssi[end, 3] + 0.008, Plots.text("240×320 (RSE)", 10, c[3])))
end

@info "PLOTING SMPI"
plot(S, sdm_smpi, m = :pentagon, alpha = 0.9,
    xlabel = "S", ylabel = "SMPI",
    legend = :none, color = [c[1] c[2] c[3]],
    size = (500, 450), tex_output_standalone = true
    )
p_SMPI = plot!(S, rse_smpi, 
    m = :c, alpha = 0.9, color = [c[1] c[2] c[3]],
    size = (500, 450), tex_output_standalone = true
    )

    if key == "head"
        ylims!(0.55, 0.86)
        annotate!((200, sdm_smpi[end, 1] + 0.01, Plots.text("480×640 (SDM)", 10, c[1])))
        annotate!((200, rse_smpi[end, 1] + 0.012, Plots.text("480×640 (RSE)", 10, c[1])))
    
        annotate!((200, sdm_smpi[end, 2] + 0.01, Plots.text("360×480 (SDM)", 10, c[2])))
        annotate!((200, rse_smpi[end, 2] + 0.011, Plots.text("360×480 (RSE)", 10, c[2])))
    
        annotate!((200, sdm_smpi[end, 3] - 0.01, Plots.text("240×320 (SDM)", 10, c[3])))
        annotate!((200, rse_smpi[end, 3] - 0.01, Plots.text("240×320 (RSE)", 10, c[3])))
    else
        annotate!((200, sdm_smpi[end, 1] - 0.008, Plots.text("480×640 (SDM)", 10, c[1])))
        annotate!((200, rse_smpi[end, 1] + 0.01, Plots.text("480×640 (RSE)", 10, c[1])))
    
        annotate!((200, sdm_smpi[end, 2] - 0.008, Plots.text("360×480 (SDM)", 10, c[2])))
        annotate!((200, rse_smpi[end, 2] + 0.008, Plots.text("360×480 (RSE)", 10, c[2])))
    
        annotate!((200, sdm_smpi[end, 3] - 0.008, Plots.text("240×320 (SDM)", 10, c[3])))
        annotate!((200, rse_smpi[end, 3] + 0.008, Plots.text("240×320 (RSE)", 10, c[3])))
    end

@info "SAVING..."
saving_path = joinpath(@__DIR__, "Plot")
savefig(p_ENL, joinpath(saving_path, "RSE_SDM_ENL_$key.tex"))
savefig(p_SSI, joinpath(saving_path, "RSE_SDM_SSI_$key.tex"))
savefig(p_SMPI, joinpath(saving_path, "RSE_SDM_SMPI_$key.tex"))