# # Creating and accessing four-vectors
#
# In collider and fixed-target analyses we routinely work with four-momenta
# $p^\mu = (p_x, p_y, p_z, E)$ in Cartesian form.
# **FourVectors.jl** stores them as an immutable **`FourVector`** with metric signature $(+,-,-,-)$,
# so the invariant mass squared is $m^2 = E^2 - \vec{p}^{\,2}$.
#
# This tutorial shows how to build on-shell momenta, read components, and extract standard HEP kinematics.

using FourVectors
using LorentzVectorBase
using Test

# ## Construction: energy *or* invariant mass
#
# You specify the spatial momentum $(p_x, p_y, p_z)$ and **exactly one** timelike quantity:
#
# - **`E`**: energy (use when it is known from reconstruction or simulation), or
# - **`M`**: invariant mass (use when the particle species is identified — the package sets $E = \sqrt{|\vec{p}|^2 + M^2}$).
#
# Supplying both or neither is an error: the four-vector must be on-shell for a single particle.

p_E = FourVector(1.0, 2.0, 3.0; E = 4.0)   # GeV-style numbers; units are your convention
p_M = FourVector(1.0, 2.0, 3.0; M = √2)    # same kinematics, mass fixes E

@test p_E ≈ p_M
@test_throws ArgumentError FourVector(1, 2, 3)
@test_throws ArgumentError FourVector(1.0, 2.0, 3.0; E = 3.0, M = 1.0)

# Integer literals promote to floating point when combined with `E` or `M` (common in generator-level ntuples).

p_promoted = FourVector(1, 2, 3; E = 4.0)
@test p_promoted isa FourVector{Float64}

# A tuple or length-4 vector is accepted; component order is always **`(px, py, pz, E)`** (not $(E,\vec{p})$).

p_tuple = FourVector((1.0, 2.0, 3.0, 4.0))
@test p_tuple ≈ p_E

# ## Lab-frame components: names and indices
#
# The type behaves like a small Julia vector: named fields match the physics labels,
# and integer indices follow the same $(p_x, p_y, p_z, E)$ ordering.

@test p_E.px == p_E[1] == 1.0
@test p_E.py == p_E[2] == 2.0
@test p_E.pz == p_E[3] == 3.0
@test p_E.E == p_E[4] == 4.0

# The spatial three-momentum $\vec{p} = (p_x, p_y, p_z)$ is available as a slice (no extra wrapper type).

@test p_E[1:3] == [p_E.px, p_E.py, p_E.pz]

# ## Kinematic scalars (exported accessors)
#
# After `using FourVectors`, standard LorentzVectorBase quantities are re-exported.
# Below, $|\vec{p}| = \sqrt{p_x^2 + p_y^2 + p_z^2}$ and $p_\mathrm{T} = \sqrt{p_x^2 + p_y^2}$.

@test mass(p_E) ≈ √2
@test transverse_momentum(p_E) == √(1.0^2 + 2.0^2)
@test spatial_magnitude(p_E) ≈ √14
@test polar_angle(p_E) ≈ acos(3 / √14)      # θ w.r.t. +z
@test azimuthal_angle(p_E) ≈ atan(2, 1)     # φ in the transverse plane
@test cos_theta(p_E) ≈ 3 / √14

# Rapidity and pseudorapidity are available the same way (`rapidity`, `pseudorapidity`) when needed for boosts along $z$.

# ## Shorter names (`pt`, `φ`, `η`, …)
#
# LorentzVectorBase also defines analysis-friendly aliases (`pt`, `phi`, `eta`, …).
# They are **not** re-exported from FourVectors; qualify the module or import what you need:

@test LorentzVectorBase.pt(p_E) ≈ transverse_momentum(p_E)
@test LorentzVectorBase.phi(p_E) ≈ azimuthal_angle(p_E)
@test LorentzVectorBase.eta(p_E) ≈ pseudorapidity(p_E)

# ## Direction as a named tuple
#
# **`spherical_coordinates`** packages the polar direction of $\vec{p}$ as `(cosθ, ϕ)`,
# matching $\cos\theta = p_z / |\vec{p}|$ and $\phi = \mathrm{atan}(p_y, p_x)$.
# This is convenient when chaining rotations (see the transformations tutorial).

Ω = spherical_coordinates(p_E)
@test Ω.cosθ ≈ cos_theta(p_E)
@test Ω.ϕ ≈ azimuthal_angle(p_E)
@test propertynames(Ω) === (:cosθ, :ϕ)

# Summary of the example four-vector:

(collect(p_E), mass(p_E), LorentzVectorBase.pt(p_E), Ω)
