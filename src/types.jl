#  === type definitions ===
#
# This file includes all type definitions of the SoundFieldSynthesis module.
# Types that are defined outside of this file are mentioned here too.

# === Secondary Sources ===
# SecondarySources
# this type is directly dfefined in secondarysources.jl


# === Source Models ===
# SourceModel
abstract SourceModel <: Number
# PointSource
type PointSource <: SourceModel
    position
    PointSource(position::Vector) = length(position)!=3 ? error("PointSource has to have 3 entries") : new(position)
end
# PlaneWave
type PlaneWave <: SourceModel
    direction
    PlaneWave(direction::Vector) = length(direction)!=3 ? error("PlaneWave has to have 3 entries") : new(direction)
end
# FocusedSource
type FocusedSource <: SourceModel
    position
    direction
    FocusedSource(position::Vector,direction::Vector) = length(position)!=3 ? error("Position of FocusedSource has to have 3 entries") :
        length(direction)!=3 ? error("Direction of FocusedSource has to have 3 entries") : new(position,direction)
end


# === Sound Field ===
# SoundField
type SoundField <: Number
    amplitude
    x
    y
    z
end

# vim:textwidth=130:
