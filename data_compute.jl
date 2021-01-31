# This file calculate the dx and dy

# Initialize parameters

Dx1, Dy1 = 480, 640
Dx2, Dy2 = 360, 480
Dx3, Dy3 = 240, 320

Nx, Ny = 960, 1280

function total_num(Nx, Ny, Dx, Dy)
    dx = [10*i for i in 3: (Dx ÷ 10)]
    dy = [10*i for i in 3: (Dy ÷ 10)]
    nx, ny = (Nx - Dx) .÷ dx, (Ny - Dy) .÷ dy
    S = (nx .+ 1) * (ny .+ 1)'

    return S
end

S1 = total_num(Nx, Ny, Dx1, Dy1)
S2 = total_num(Nx, Ny, Dx2, Dy2)
S3 = total_num(Nx, Ny, Dx3, Dy3)

Set_S = Set(intersect(S1, S2, S3))


