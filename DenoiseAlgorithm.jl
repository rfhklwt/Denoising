module DenoiseAlgorithm

using Statistics
export make_sub_holo, SDM, RSE

function make_sub_holo(hologram::AbstractArray, Dx::Int, Dy::Int, dx::Int, dy::Int)
    Nx, Ny = size(hologram)
    # total number of sub-holograms
    nx, ny = (Nx - Dx) ÷ dx, (Ny - Dy) ÷ dy
    S = (nx + 1) * (ny + 1)
    # Initialize a tensor to store S sub-holograms
    sub_holo_tensor = zeros(Nx, Ny, S)
    clock = 1
    for i in 0: nx, j in 0: ny
        sub_holo_tensor[1 + i*dx: Dx + i*dx, 1 + j*dy: Dy + j*dy, clock] .= hologram[1 + i*dx: Dx + i*dx, 1 + j*dy: Dy + j*dy]
        clock += 1
    end

    return sub_holo_tensor
end

# SDM method, see in https://ieeexplore.ieee.org/document/7276984/metrics#metrics
SDM(img_tensor::AbstractArray) = mean(img_tensor, dims=3)

# redundant speckle elimination (RSE) method, see in https://www.osapublishing.org/ao/abstract.cfm?uri=ao-59-16-5066
function RSE(img_tensor::AbstractArray)
    dims_1, dims_2, dims_3 = size(img_tensor)
    mean_tensor = similar(img_tensor, dims_1, dims_2)

    for i in 1: dims_1, j in 1: dims_2
        mean_tensor[i, j] = unique(@view img_tensor[i, j, :]) |> mean
    end

    return mean_tensor
end

end # module

