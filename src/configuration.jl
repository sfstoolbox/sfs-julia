type Configuration
    # === Secondary Sources ===
    # Number of secondary sources
    secondarysources_number::Integer
    # Diameter/Length of secondary source array
    secondarysources_size::Float64
    # Center of array, X0
    secondarysources_center::Vector{Float64}
    # Array geometry
    # Possible values are: "line", "box", "circle", "sphere"
    secondarysources_geometry::String
    # Vector containing custom secondary source positions and directions.
    # conf.secondary_sources.x0 = [x0; y0; z0; nx0; ny0; nz0];
    secondarysources_x0::Array
    # Grid for the spherical array. Note, that you have to download and install the
    # spherical grids from an additiona source. For available grids see:
    # http://github.com/sfstoolbox/data/tree/master/spherical_grids
    # An exception are Gauss grids, which are available via 'gauss' and will be
    # calculated on the fly allowing very high number of secondary sources.
    secondarysources_grid::String
end
Configuration(; secondarysources_number=64,
                secondarysources_size=3,
                secondarysources_center=[0,0,0],
                secondarysources_geometry="circle",
                secondarysources_x0=[],
                secondarysources_grid="equally_spaced_points") =
                    Configuration(secondarysources_number,
                                  secondarysources_size,
                                  secondarysources_center,
                                  secondarysources_geometry,
                                  secondarysources_x0,
                                  secondarysources_grid)
