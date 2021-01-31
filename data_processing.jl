using HoloProcessing
using Statistics
using DataFrames
using JLD

function mean_repeated_sort(src::DataFrame, Mat::AbstractMatrix; index::Integer)
    if size(src, 2) != size(Mat, 2)
        @error string(DimensionMismatch("The column size of src must equal to Mat"))
        return
    end
    sort_Mat = sortslices(Mat, dims=1, by= x -> x[index])

    row, ~ = size(Mat)
    start_point, end_point = 1, 1
    while start_point <= row && end_point <= row
        while end_point <= row && sort_Mat[end_point, index] == sort_Mat[start_point, index]
            end_point += 1
        end
        # mean
        mean_array = mean(sort_Mat[start_point: end_point - 1, :], dims=1)

        push!(src, mean_array)
        # update pointer
        start_point = end_point
    end

    return src
end


function data_convert_to_df(PATH::String)
    @info "LOADING..."
    data = load(PATH)["data"]

    @info "convert to Matrix..."
    S = [each.S for each in data]
    ssi = [each.ssi for each in data]
    smpi = [each.smpi for each in data]
    enl = [each.enl for each in data]

    Mat = [S ssi smpi enl]

    df = DataFrame(S=Int[], ssi=Float64[], smpi=Float64[], enl=Float64[])
    DF = mean_repeated_sort(df, Mat; index=1)
    @info "Return DF"
    return DF
end
