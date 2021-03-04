function export_data(PATH::String, s::Int)
    data = load(PATH)["data"]
    return filter(x -> x.S == s, data)[1]
end

function pushing!(data::ReconstructedImage, S, dx, dy, ssi, smpi, enl)
    push!(S, data.S)
    push!(dx, data.dx)
    push!(dy, data.dy)
    push!(ssi, data.ssi)
    push!(smpi, data.smpi)
    push!(enl, data.enl)
end

function detail_img(img::AbstractArray, key::String)
    if key == "head"
        return @view img[50:250, 250:450]
    elseif key == "tail"
        return @view img[50:250, 150:350]
    else
        @error "the key name must be head or tail..."
    end
end