using HoloProcessing
using Images
using FFTW
using ImageView
using DSP

# load hologram with eltype Float64
PATH = joinpath(@__DIR__, "hologram")
saving_path = joinpath(@__DIR__, "export")
holo_name = "head.bmp"
holo = load_image(PATH, holo_name)
Nx, Ny = size(holo)
scale = 4000000
P = plan_fft(holo)
re_img = reconst(holo, P, scale; shift=true)

key = holo_name[1:4]

# generate mask
masks = [ones(size(holo) .÷ 2) zeros(size(holo) .÷ 2); zeros(size(holo) .÷ 2) zeros(size(holo) .÷ 2)]
masks = zeros(size(holo))
m, n = Nx ÷ 2, Ny ÷ 2
masks[m ÷ 2: 3m ÷ 2, n ÷ 2: 3n ÷ 2] .= 1

# convolution
conv_img = conv(fftshift(P * fftshift(holo)), fftshift(P * fftshift(masks)))
raw_img = real.(conv_img .* conj(conv_img))
final_img = clamp!(1000000 * normalize(raw_img), 0, 1)
conv_img_final = final_img[480: 1439, 640: 1919]

# save img
save(joinpath(saving_path, "conv_img_$key.pdf"), conv_img_final)