```julia
# I. 生成原始再现像并且把图像保存下来
include("generate_re_img.jl")

# II. Generate sdm_img
include("generate_sdm_img.jl")

# III. 生成降噪后的图像，同时以jld类型被保存下来
include("generate_rse_img.jl")
include("generate_sdm_img.jl")
include("generate_ldr_img.jl")

# IV. 对jld数据进行后续处理，把相同`S`的数据进行平均，得到平均值，再将这些评价值存成cvs的形式
include("data_processing_main.jl")

# V. 保存图(Optional)
include("extract_data_main.jl")

# 保存S, dx, dy = 70, 50, 100下的三种算法的图和指标数据，保存在export文件夹中（论文用）
include("export_data_main.jl")

```

## 绘制图
1. 先在`data_plot.ipynb`上调整图的坐标、颜色等方式，最后调整完成后将其整合到`plot_sdm_rse.jl`文件上。
2. 通过直接`include("plot_sdm_rse.jl")`可获取得到对应的`tikz`代码，以`tex`文件的格式保存。
3. `tex`文件存在`Plot`文件夹里面，通过`latex_make.jl`将`tex`文件编译得到对应的`pdf`图文件。



## 一些文件的作用

1. `convolution.jl`里面实现再现像与`sinc`函数的卷积

2. `bar_plot.ipynb`：绘制直方图（论文用）
3. `sinc_plot.ipynb`：绘制`sinc`函数的三维图和等高线图
4. `speed_compare.jl`：计算三种算法的速度