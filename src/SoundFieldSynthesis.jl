module SoundFieldSynthesis

# Check if this will work
import Base: size, length, getindex

export Configuration, SoundField, SecondarySources, PlaneWave, PointSource, FocusedSource, selection, distance

include("configuration.jl")
include("mathtools.jl")
include("types.jl")
include("secondarysources.jl")

end # module
