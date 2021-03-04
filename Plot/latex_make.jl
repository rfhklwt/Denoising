for file in readdir(@__DIR__)
    if !occursin(".tex", file)
        continue
    end

    run(`xelatex $file`)
    rm(joinpath(@__DIR__, string(file[1: end - 3], "log")))
    rm(joinpath(@__DIR__, string(file[1: end - 3], "aux")))
end
