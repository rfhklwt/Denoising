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