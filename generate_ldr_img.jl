@info "Loading Pkg"
using HoloProcessing
using Images
using FFTW
using ImageView
using JLD
using Dates


include("data_compute.jl")

@info "Finishing loading"
# Beginning
@info Dates.now()
# load hologram with eltype Float64
PATH = joinpath(@__DIR__, "hologram")
holo_name = "tail.bmp"
holo = load_image(PATH, holo_name)
Nx, Ny = size(holo)
scale = 4000000
P = plan_fft(holo)
re_img = reconst(holo, P, scale; shift=true)

# original image
ori_img, ori_img_zoom, ori_img_local = geometry_operate(re_img, holo_name)
key = holo_name[1: 4]

# Setting parameter
# N = 2
# N = 8 // 3
# N = 4


for N in [2, 4]
    # Store de-noising image with (S, dx, dy). 
    denoised_imgs = []
    denoised_imgs_zoom = []
    denoised_imgs_local = []

    Dx, Dy = Nx ÷ N, Ny ÷ N
    sub_P = plan_fft(similar(holo, Dx, Dy))
    # make path
    key_dir = joinpath(@__DIR__, "Data", key, "LDR", string(Dx, "_", Dy))

    !isdir(key_dir) && mkpath(key_dir)

    ## De-noising
    for dx in 30: 10: Dx, dy in 30: 10: Dy
        nx, ny = (Nx - Dx) ÷ dx, (Ny - Dy) ÷ dy
        S = (nx + 1) * (ny + 1)
        if S ∉ Set_S
            continue
        end
        @info "Processing" (N, S, dx, dy)
        @info Dates.now()
        tensor = make_sub_holo(holo, Dx, Dy, dx, dy; dims_shrink=true)
        
        @inbounds Threads.@threads for ind in CartesianIndices(1: size(tensor, 3))
            k = ind.I[1]
            tensor[:, :, k] = reconst(tensor[:, :, k], sub_P, scale ÷ N^2; shift=true)
        end

        ldr_img = LDR(tensor, N)
        ldr_img, ldr_img_zoom, ldr_img_local = geometry_operate(ldr_img, holo_name)

        denoised_img = initialize(ReconstructedImage(ldr_img, S, dx, dy), ori_img)
        denoised_img_zoom = initialize(ReconstructedImage(ldr_img_zoom, S, dx, dy), ori_img_zoom)
        denoised_img_local = initialize(ReconstructedImage(ldr_img_local, S, dx, dy), ori_img_local)

        @info "Pushing de-noised image"
        push!(denoised_imgs, denoised_img)
        push!(denoised_imgs_zoom, denoised_img_zoom)
        push!(denoised_imgs_local, denoised_img_local)
        
        # save(joinpath(key_dir, string("ldr ", S, " # ", dx, "_", dy, ".pdf")), ldr_img)
        # save(joinpath(key_dir, string("ldr zoom ", S, " # ", dx, "_", dy, ".pdf")), zoom_ldr_img)
    end
    @info "Saving"
    save(joinpath(key_dir, "ldr_data.jld"), "data", denoised_imgs)
    save(joinpath(key_dir, "ldr_data_zoom.jld"), "data", denoised_imgs_zoom)
    save(joinpath(key_dir, "ldr_data_local.jld"), "data", denoised_imgs_local)
end

@info "Total Complete"
@info Dates.now()