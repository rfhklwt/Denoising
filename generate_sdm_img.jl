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
holo_name = "head.bmp"
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
for N in [2, 8 // 3, 4]
    # if N in [8 // 3, 4]
    #     continue
    # end 

    # Store de-noising image with (S, dx, dy). 
    denoised_imgs = []
    denoised_imgs_zoom = []
    denoised_imgs_local = []

    Dx, Dy = Nx ÷ N, Ny ÷ N

    # make path
    key_dir = joinpath(@__DIR__, "Data", key, "SDM", string(Dx, "_", Dy))

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
        tensor = make_sub_holo(holo, Dx, Dy, dx, dy)
        
        for k in 1: size(tensor, 3)
            tensor[:, :, k] = reconst(tensor[:, :, k], P, scale ÷ N^2; shift=true)
        end

        sdm_img = SDM(tensor)
        sdm_img, sdm_img_zoom, sdm_img_local = geometry_operate(sdm_img, holo_name)

        denoised_img = initialize(ReconstructedImage(sdm_img, S, dx, dy), ori_img)
        denoised_img_zoom = initialize(ReconstructedImage(sdm_img_zoom, S, dx, dy), ori_img_zoom)
        denoised_img_local = initialize(ReconstructedImage(sdm_img_local, S, dx, dy), ori_img_local)

        @info "Pushing de-noised image"
        push!(denoised_imgs, denoised_img)
        push!(denoised_imgs_zoom, denoised_img_zoom)
        push!(denoised_imgs_local, denoised_img_local)
        
        # save(joinpath(key_dir, string("sdm ", S, " # ", dx, "_", dy, ".pdf")), sdm_img)
        # save(joinpath(key_dir, string("sdm zoom ", S, " # ", dx, "_", dy, ".pdf")), zoom_sdm_img)
    end
    @info "Saving"
    save(joinpath(key_dir, "sdm_data.jld"), "data", denoised_imgs)
    save(joinpath(key_dir, "sdm_data_zoom.jld"), "data", denoised_imgs_zoom)
    save(joinpath(key_dir, "sdm_data_local.jld"), "data", denoised_imgs_local)
end

@info "Total Complete"
@info Dates.now()