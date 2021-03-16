function make_sub_holo(hologram::AbstractArray, Dx::Int, Dy::Int, dx::Int, dy::Int; dims_shrink=false)
    Nx, Ny = size(hologram)
    # total number of sub-holograms
    nx, ny = (Nx - Dx) ÷ dx, (Ny - Dy) ÷ dy
    S = (nx + 1) * (ny + 1)
    
    if dims_shrink  # generate sub_hologram with Dx × Dy
        sub_holo_tensor = zeros(Dx, Dy, S)
        clock = 1
        @inbounds for i in 0: nx, j in 0: ny 
            sub_holo_tensor[:, :, clock] .= @view hologram[1 + i*dx: Dx + i*dx, 1 + j*dy: Dy + j*dy]
            clock += 1
        end
    else    # generate sub_hologram with Nx × Ny
        # Initialize a tensor to store S sub-holograms
        sub_holo_tensor = zeros(Nx, Ny, S)
        clock = 1
        @inbounds for i in 0: nx, j in 0: ny
            sub_holo_tensor[1 + i*dx: Dx + i*dx, 1 + j*dy: Dy + j*dy, clock] .= @view hologram[1 + i*dx: Dx + i*dx, 1 + j*dy: Dy + j*dy]
            clock += 1
        end
    end

    return sub_holo_tensor
end



# SDM method, see in https://ieeexplore.ieee.org/document/7276984/metrics#metrics
SDM(img_tensor::AbstractArray) = mean(img_tensor, dims=3)

# redundant speckle elimination (RSE) method, see in https://www.osapublishing.org/ao/abstract.cfm?uri=ao-59-16-5066
function RSE(img_tensor::AbstractArray{T, 3}) where T
    dims_1, dims_2, dims_3 = size(img_tensor)
    mean_img = zeros(dims_1, dims_2)

    @inbounds for i in 1: dims_1, j in 1: dims_2
        hash_tab = Set{T}()
        clock = 0
        @inbounds for k in 1: dims_3
            if img_tensor[i, j, k] ∉ hash_tab
                push!(hash_tab, img_tensor[i, j, k])
                mean_img[i, j] += img_tensor[i, j, k]
            clock += 1
            end
        end
        mean_img[i, j] /= clock
    end

    return mean_img
end

# much faster version
function RSE_parallel(img_tensor::AbstractArray{T, 3}) where T
    dims_1, dims_2, dims_3 = size(img_tensor)
    mean_img = zeros(dims_1, dims_2)

    @inbounds Threads.@threads for ind in CartesianIndices((1: dims_1, 1: dims_2))
        i, j = ind.I
        hash_tab = Set{T}()
        clock = 0
        @inbounds for k in 1: dims_3
            if img_tensor[i, j, k] ∉ hash_tab
                push!(hash_tab, img_tensor[i, j, k])
                mean_img[i, j] += img_tensor[i, j, k]
            clock += 1
            end
        end
        mean_img[i, j] /= clock
    end

    return mean_img
end

# low-dimensional reconstruction (LDR) method, see in https://www.osapublishing.org/ao/abstract.cfm?doi=10.1364/AO.414773
function LDR(img_tensor::AbstractArray, N::Integer)
    # Shuffling
    shuffle_tensor = @view img_tensor[:, :, randperm(size(img_tensor, 3))]
    
    # denoising
    mean_tensor = LDR_denosing(shuffle_tensor, N)

    # aggregation
    denoised_img = LDR_aggregation(mean_tensor, N)

    # mean 
    return mapwindow(mean, denoised_img, (3, 3))
end


function LDR_denosing(img_tensor::AbstractArray, N::Integer)
    dims_1, dims_2, dims_3 = size(img_tensor)
    mean_tensor = similar(img_tensor, dims_1, dims_2, N^2)

    δ = dims_3 ÷ N^2

    @inbounds Threads.@threads for ind in CartesianIndices(1: N^2)
        k = ind.I[1]
        mean_tensor[:, :, k] = mean(img_tensor[:, :, 1 + (k - 1) * δ: k * δ], dims=3)
    end

    return mean_tensor
end

function LDR_aggregation(img_tensor::AbstractArray, N::Integer)
    dims_1, dims_2, _ = size(img_tensor)
    denoised_img = similar(img_tensor, dims_1 * N, dims_2 * N)

    @inbounds Threads.@threads for ind in CartesianIndices((1: N, 1: N))
    #@inbounds for i in 1: N, j in 1: N
        i, j = ind.I
        denoised_img[i: N: end, j: N: end] .= @view img_tensor[:, :, i + j - 1]
    end

    return denoised_img
end

