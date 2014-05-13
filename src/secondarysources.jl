# define secondary source type
# ensure that it is a nx7 matrix
type SecondarySources
    x0::Array{Number,2}

    SecondarySources(x0::Array{Number,2}) = size(x0,2)!=7 ? error("SecondarySources has to have 7 columns") : new(x0)
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



