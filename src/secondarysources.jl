# define secondary source type
# ensure that it is a nx7 matrix
immutable SecondarySources
    positions::Array{Float64,2}
    directions::Array{Float64,2}
    weights::Vector{Float64}
    SecondarySources(x0::Array) = size(x0,2)!=7 ? error("SecondarySources has to have 7 columns") : new(x0[:,1:3],x0[:,4:6],x0[:,7])
    SecondarySources(positions::Array,directions::Array,weights::Vector) = new(positions,directions,weights)
end
# constructor using the configuration
function SecondarySources(conf::Configuration)
    # get configuration entries
    x0 = conf.secondarysources_x0
    number = conf.secondarysources_number
    geometry = conf.secondarysources_geometry
    X0 = conf.secondarysources_center
    L = conf.secondarysources_size
    # check if we have pre-defined secondary sources
    # FIXME: see, if we can do this in a better way. Maybe by passing the x0
    # directly to any given soundfield function instead of predefining it in the
    # configuration.
    if ~isempty(x0)
        SecondarySources(x0)
        return
    end
    x0 = zeros(number,7);
    if geometry=="line" || geometry=="linear"
        # === Linear array ===
        # Positions of the secondary sources
        x0[:,1] = X0[1] .+ linspace(-L/2,L/2,number)
        x0[:,2] = X0[2] .* ones(number,1)
        x0[:,3] = X0[3] .* ones(number,1)
        # Direction of the secondary sources pointing to the -y direction
        x0[:,4:6] = directionvector(x0[:,1:3],x0[:,1:3].+[0,-1,0]')
        # equal weights for all sources
        x0[:,7] = ones(number,1)
    elseif geometry=="circle" || geometry=="circular"
        # === Circular array ===
        # Azimuth angles
        phi = linspace(0,(2-2/number)*pi,number) # 0..2pi
        # Positions of the secondary sources
        (x,y,z) = sph2cart(phi,0,L/2)
        x0[:,1:3] = [x y z] .+ X0'
        # Direction of the secondary sources
        x0[:,4:6] = directionvector(x0[:,1:3],X0);
        # equal weights for all sources
        x0[:,7] = ones(number)
    end
    # construct the secondary sources
    SecondarySources(x0)
end

# add normal functions to work with SecondarySources
import Base.size
import Base.length
import Base.getindex
size(x0::SecondarySources,dim::Integer) = size(x0.positions,1)
size(x0::SecondarySources) = size(x0.positions,1)
length(x0::SecondarySources) = size(x0)
getindex(x0::SecondarySources,idx::Integer) = SecondarySources(x0.positions[idx,:],x0.directions[idx,:],[x0.weights[idx]])
getindex(x0::SecondarySources,range::UnitRange) = SecondarySources(x0.positions[range,:],x0.directions[range,:],x0.weights[range])
getindex(x0::SecondarySources,idx::BitVector) = SecondarySources(x0.positions[idx,:],x0.directions[idx,:],x0.weights[idx])


# add all the functions dealing with secondary sources


# === distance between secondary sources =================================
function distance(x0::SecondarySources,approx::Bool)
    if size(x0)==1
        # if we have only one secondary source
        dx0 = Inf;
    else
        if approx
            # approximate by using only the first <=100 sources
            x0.positions = x0.positions[1:min(100,size(x0)),:];
        end
        dx0_single = zeros(size(x0),1)
        for ii=1:size(x0)
            # first secondary source position
            x01 = x0.positions[ii,:];
            # all other positions
            x02 = [x0.positions[1:ii-1,:]; x0.positions[ii+1:end,:]];
            # get distance between x01 and all secondary sources within x02
            dist = vectornorm(x02.-x01,2);
            # get the smallest distance (which is the one to the next source)
            dx0_single[ii] = minimum(dist);
        end
        # get the mean distance between all secondary sources
        dx0 = mean(dx0_single);
    end
    return dx0
end
distance(x0::SecondarySources) = distance(x0,false)


# === secondary source selection for WFS =================================
function selection(x0::SecondarySources,xs::PlaneWave)
    #
    #      / 1, if nk nx0 > 0
    # a = <
    #      \ 0, else
    #
    # see Wierstorf (2014), p.25 (2.47)
    #
    idx = vectorproduct(x0.directions,xs.direction',2).>=eps()
    # return only selected secondary sources
    x0[idx], idx
end
function selection(x0::SecondarySources,xs::PointSource)
    #
    #      / 1, if (x0-xs) nx0 > 0
    # a = <
    #      \ 0, else
    #
    # see Wierstorf (2014), p.26 (2.54) and p.27 (2.59)
    #
    idx = vectorproduct(x0.positions-xs.direction',x0.directions,2).>=eps()
    # return only selected secondary sources
    x0[idx], idx
end
function selection(x0::SecondarySources,xs::FocusedSources)
    # NOTE: (xs-x0) nx0 > 0 is always true for a focused source
    #
    #      / 1, if nxs (xs-x0) > 0
    # a = <
    #      \ 0, else
    #
    # see Wierstorf (2014), p.27 (2.67)
    #
    idx = vectorproduct(xs.direction',xs.position'-x0.positions,2).>=eps()
    # return only selected secondary sources
    x0[idx], idx
end


