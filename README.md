```julia
# 生成原始再现像并且把图像保存下来
include("generate_re_img.jl")

# Generate sdm_img
include("generate_sdm_img.jl")

# 生成降噪后的图像，同时以jld类型被保存下来
include("generate_rse_img.jl")
include("generate_sdm_img.jl")

# 对jld数据进行后续处理，把相同`S`的数据进行平均，得到平均值，再将这些评价值存成cvs的形式
include("data_processing_main.jl")

# 绘制图

```

