using HoloProcessing
using CSV

include("data_processing.jl")
key = "tail"
method_name = "RSE"
path = joinpath(@__DIR__, "Data", key, method_name)

for folder in readdir(path, join=true)
    for each in readdir(folder)
        if !occursin("zoom", each) && !occursin("local", each)
            continue
        end
        data = data_convert_to_df(joinpath(folder, each))
        CSV.write(joinpath(folder, string(each[1: end - 3], "csv")), data)
    end
end
        
