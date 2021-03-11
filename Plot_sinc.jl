using Plots
using LinearAlgebra
pgfplotsx()
saving_path = joinpath(@__DIR__, "Plot")

x = range(-20, stop = 20, length = 200)
y = range(-20, stop = 20, length = 200)

f(x, y) = sinc(x)sinc(y)

sinc_plot = plot(x, y, f, linetype=:surface, camera = (60, 60), tex_output_standalone = true)

savefig(sinc_plot, joinpath(saving_path, "RSE_SDM_ENL_$key.tex"))

surface(x, y, z')

surface(x, y, (x, y) -> sinc(x)sinc(y))

theme(:ggplot2)
f(x, y) = sinc(x)sinc(y)
f(x,y) = x^2 + y^2
x = -10:10
y = x
plot(x, y, f, linetype=:wireframe)

savefig("")
linetype=:surface

f(x,y) = 2 - (x^2 + y^2)
xs = ys = range(-2, stop=2, length=100)
zs = [f(x,y) for y in ys, x in xs]

surface(xs, ys, zs, camera=(40, 25), legend=false)

savefig(p_ENL, joinpath(saving_path, "RSE_SDM_ENL_$key.tex"))