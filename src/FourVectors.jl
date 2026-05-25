module FourVectors

using StaticArrays
using LinearAlgebra
using LorentzVectorBase

export FourVector, FourVectorCyl

const ALL_GETTER_FUNCTIONS = vcat(
    :transverse_momentum,
    :spatial_magnitude,
    :mass,
    :mass2,
    :boost_beta,
    :boost_gamma,
    :rapidity,
    :polar_angle,
    :cos_theta,
    :cos_phi,
    :sin_phi,
    :azimuthal_angle,
    :pseudorapidity,
    :transverse_mass,
    :transverse_mass2,
)

const HEP_ALIAS_FUNCTIONS = (
    :pt,
    :pt2,
    :eta,
    :phi,
    :mt,
    :mt2,
    :px,
    :py,
    :pz,
    :energy,
)

for func_sym in ALL_GETTER_FUNCTIONS
    @eval import LorentzVectorBase: $(func_sym)
    @eval export $(func_sym)
end

for func_sym in HEP_ALIAS_FUNCTIONS
    @eval import LorentzVectorBase: $(func_sym)
    @eval export $(func_sym)
end

export spherical_coordinates
include("structs.jl")
include("cylindrical.jl")
include("conversions.jl")

export fromPtEtaPhiE, fast_mass
export deltaphi, deltaeta, deltar, Δϕ, Δη, ΔR
include("separation.jl")

export Rx, Ry, Rz, Bz, transform_to_cmf, rotate_to_plane
include("transformations.jl")

end # module
