module FourVectors

using StaticArrays
using LinearAlgebra
using LorentzVectorBase

export FourVector

# Access the list of function names relevant for this package
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
    :pseudorapidity
)

# Loop over each function name and import and export it
for func_sym in ALL_GETTER_FUNCTIONS
    # Import the function from LorentzVectorBase
    @eval import LorentzVectorBase: $(func_sym)
    # Export the function from this module
    @eval export $(func_sym)
end
export spherical_coordinates
include("structs.jl")

export Rx
export Ry
export Rz
export Bz
export transform_to_cmf, rotate_to_plane
include("transformations.jl")


end # module
