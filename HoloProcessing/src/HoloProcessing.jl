module HoloProcessing
    using Images
    using FFTW
    using Statistics
    using Random
    
    include("evaluation_function.jl")
    include("algorithms.jl")
    include("types.jl")
    include("operate.jl")

    export ReconstructedImage
    export initialize, brightness, color, normalize, reconst, load_image, geometry_operate
    export contrast, SSI, SMPI, ENL
    export make_sub_holo, SDM, RSE, RSE_parallel, LDR

end # module