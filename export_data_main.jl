# This file export SDM and RSE data as .pdf and .csv
# Saving path: ./export/$key
@info "LOADING Pkg..."
using JLD
using HoloProcessing
using CSVFiles
using DataFrames
using ImageMagick

include("export_data.jl")
@info "END LOADING"

key = "tail"
path = joinpath(@__DIR__, "Data", key)
# parameter
s = 70

method = Vector{String}()
dims = Vector{String}()
S = Vector{Int}()
dx = Vector{Int}()
dy = Vector{Int}()
ssi = Vector{Float64}()
smpi = Vector{Float64}()
enl = Vector{Float64}()

# Saving path
saving_path = joinpath(@__DIR__, "export", key)
!isdir(saving_path) && mkpath(saving_path)


# ./Data/LDR ...
for folder in readdir(path, join=true)
    # ignore the pdf file
    occursin(".pdf", folder) && continue
    # 240_320 ...
    for sub_folder in readdir(folder)
        # sdm_data_local
        for JLD_file in readdir(joinpath(folder, sub_folder))
            # ignore the not JLD file
            !occursin(".jld", JLD_file) && continue
            @info string("Exporting ", JLD_file[1:(end - 4)], "_", sub_folder)

            data = export_data(joinpath(folder, sub_folder, JLD_file), s)
            save(joinpath(saving_path, string(JLD_file[1:(end - 4)], "_", sub_folder, ".pdf")), data.data)
            
            if occursin("zoom", JLD_file)
                detail = detail_img(data.data, key)
                save(joinpath(saving_path, string(JLD_file[1:(end - 4)], "_", sub_folder, "detail.pdf")), detail)
            end
            
            push!(method, JLD_file[1:(end - 4)])
            push!(dims, sub_folder)
            pushing!(data, S, dx, dy, ssi, smpi, enl)
        end
    end
end

@info "Saving..."
df = DataFrame(Method = method, Dims = dims, S = S, Dx = dx, Dy = dy, SSI = ssi, SMPI = smpi, ENL = enl)

save(joinpath(saving_path, "export_data.csv"), df)



