@info "Ploting"
plot(sdm_data.S, sdm_data.ssi, leg=false, m=:c, ms = 4.5, xlabel="S", ylabel="ssi", label = "SDM", alpha=0.6)
p = plot!(rse_path.S, rse_path.ssi, leg=false, m=:c, ms = 4.5, label="RSE", alpha=0.6)


# p2 = plot(sdm_DF, DF.smpi, seriestype = :scatter, alpha=0.7)

# p3 = plot(sdm_DF, DF.enl, seriestype = :scatter, alpha=0.7)