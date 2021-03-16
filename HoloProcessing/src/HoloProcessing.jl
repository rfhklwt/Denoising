module HoloProcessing
    using Images
    using FFTW
    using Statistics
    using Random
    
    include("evaluation_function.jl")
    include("algorithms.jl")

    export ReconstructedImage
    export initialize, brightness, color, normalize, reconst, load_image, geometry_operate
    export contrast, SSI, SMPI, ENL
    export make_sub_holo, SDM, RSE, RSE_parallel, LDR

    abstract type AbstractImage end

    mutable struct ReconstructedImage <: AbstractImage
        data::AbstractMatrix
        S::Int
        dx::Int
        dy::Int
        ssi::Float64
        smpi::Float64
        enl::Float64
    end

    ReconstructedImage(data, S, dx, dy) = ReconstructedImage(data, S, dx, dy, NaN, NaN, NaN)

    function initialize(img::ReconstructedImage, ori_img::AbstractMatrix)
        img.ssi = SSI(ori_img, img.data)
        img.smpi = SMPI(ori_img, img.data)
        img.enl = ENL(img.data)

        return img 
    end

    brightness(c) = 0.3 * c.r + 0.59 * c.g + 0.11 * c.b

    # Covert image to data array
    brightness(img::AbstractArray) = brightness.(img)

    # Normalize image
    normalize(x) = (x .- minimum(x)) ./ (maximum(x) - minimum(x))

    # Covert data array to image
    color(x::AbstractArray) = Gray.(x)

    # Load image
    function load_image(PATH, image_name::String; data=true)
        img = load(joinpath(PATH, image_name))
        
        if data
            return brightness(img)
        else
            return img
        end
    end

    # Reconstructing hologram
    function reconst(hologram::AbstractArray, P::FFTW.cFFTWPlan, scalefactor::Number; shift=false)
        if shift
            fft_img = fftshift(P * fftshift(hologram))
        else
            fft_img = P * hologram
        end
        raw_img = real.(fft_img .* conj(fft_img))
        clamp!(scalefactor * normalize(raw_img), 0, 1)
    end

    # Generate shift_img and ori_img with respect hologram of head and tail (custom version)
    function geometry_operate(re_img, holo_name)
        if occursin("head", holo_name)
            shift_img = [re_img[:, 1251: 1280] re_img[:, 1: 1250]]
            zoom_img = @view shift_img[451: 950, 1: 500]
            local_img = @view zoom_img[150: 166, 346: 362]
        elseif occursin("tail", holo_name)
            shift_img = [re_img[37: 960, :]; re_img[1: 36, :]]
            zoom_img = @view shift_img[476: 956, 14: 494]
            local_img = @view zoom_img[123: 139, 148: 164]
        else
            error("Only head or tail can be processed.")
        end
        
        return shift_img, zoom_img, local_img
    end

end # module