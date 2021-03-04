# Contrast
contrast(img::AbstractMatrix) = std(img) / mean(img)

# SSI
SSI(noised, filtered) = contrast(filtered) / contrast(noised)

# SMPI
SMPI(noised::AbstractMatrix, filtered::AbstractMatrix) = (1 + abs(mean(filtered) - mean(noised))) * (std(filtered) / std(noised))

# ENL 
ENL(img) = (mean(img) / std(img)) ^2