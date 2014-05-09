# one idea is to define SecondarySources as a subtype of Matrix and say that it
# has to be n x 7
type SecondarySources
    x0::Array{Float64,2}

    SecondarySources(x0::Array{Float64,2}) = size(x0,2)!=7 ? error("SecondarySource has to have 7 columns") : new(x0)
end


# add all the functions dealing with secondary sources


# === distance between secondary sources
function distance(x0::SecondarySources,approx::Bool)
    # add code
end
distance(x0::SecondarySources) = distance(x0,false)


# === secondary source selection for WFS
function selection(x0::SecondarySources,xs::PlaneWave)
    # add code
    x0, idx
end
function selection(x0::SecondarySources,xs::PointSource)
    # add code
    x0, idx
end
# ...



