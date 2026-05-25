module FourVectors

using StaticArrays
using LinearAlgebra
using LorentzVectorBase

import LorentzVectorBase:
    cos_theta,
    azimuthal_angle,
    polar_angle,
    boost_gamma,
    transverse_momentum,
    pseudorapidity,
    mass

export FourVector, FourVectorCyl
export spherical_coordinates
export fromPtEtaPhiE, fast_mass
export Rx, Ry, Rz, Bz, transform_to_cmf, rotate_to_plane

include("structs.jl")
include("cylindrical.jl")
include("conversions.jl")
include("transformations.jl")

end # module
