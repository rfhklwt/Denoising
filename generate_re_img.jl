using HoloProcessing
using Images
using FFTW
using ImageView

# load hologram with eltype Float64
PATH = "/home/qling/Documents/hologram"
holo_name = "tail.bmp"
holo = load_image(PATH, holo_name)
Nx, Ny = size(holo)
scale = 4000000
P = plan_fft(holo)
re_img = reconst(holo, P, scale; shift=true)

shift_img, zoom_img = geometry_operate(re_img, holo_name)

# save reconstructed image
key = holo_name[1: 4]

key_dir = joinpath(@__DIR__, "Data", key)

!isdir(key_dir) && mkpath(key_dir)

save(joinpath(key_dir, "ori $key.pdf"), re_img)
save(joinpath(key_dir, "ori zoom $key.pdf"), zoom_img)