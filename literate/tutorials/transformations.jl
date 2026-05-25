# # Lorentz transformations
#
# Changing reference frame means a Lorentz transformation on $p^\mu$.
# This package implements **active** transformations: the **frame stays fixed** and the four-momentum is rotated or boosted.
# That matches the usual HEP habit of “rotating the vector into the $z$ axis” before a longitudinal boost.
#
# All transforms preserve $m^2 = E^2 - |\vec{p}|^2$ (numerically, up to round-off).

using FourVectors
using Test

p = FourVector(0.5, 0.5, 0.5; M = 1.0)

# ## Spatial rotations (`Rx`, `Ry`, `Rz`)
#
# Rotations act on $(p_x, p_y, p_z)$ only; **$E$ is unchanged** (orthogonal transformation of the spatial part).
# Angles are in radians, right-handed, about the lab axes:
#
# - **`Rx(p, α)`** — rotation about $x$
# - **`Ry(p, θ)`** — rotation about $y$ (often used to bring $\vec{p}$ into the $x$–$z$ plane)
# - **`Rz(p, φ)`** — rotation about $z$ (azimuthal alignment)
#
# Composing with the opposite angle returns the original momentum:

α = 0.4
@test Rx(Rx(p, α), -α) ≈ p
@test Ry(Ry(p, α), -α) ≈ p
@test Rz(Rz(p, α), -α) ≈ p

p_ry = Ry(p, π / 4)

# ## Longitudinal boost (`Bz`)
#
# **`Bz(p, γ)`** applies a boost along the lab **$z$** axis with Lorentz factor $\gamma$.
# Use **`boost_gamma(p)`** (from LorentzVectorBase) when you need the $\gamma$ of an existing four-momentum.
#
# Sign convention: **negative $\gamma$** reverses the boost direction ($\beta \to -\beta$ at fixed $|\gamma|$).
# This is handy when chaining “boost to lab” and “boost back to rest” without recomputing $\beta$.

γ = 2.5
@test Bz(Bz(p, γ), -γ) ≈ p

p_boosted = Bz(p, γ)

# ## Chaining transforms (`|>`)
#
# `Rx(α)`, `Ry(θ)`, `Rz(φ)`, and `Bz(γ)` can be partially applied to obtain unary maps,
# which compose cleanly in pipelines — the same pattern as in the π⁰ decay tutorial.

p_pipeline = p |> Ry(π / 6) |> Rz(0.2) |> Bz(1.5)
@test p_pipeline isa FourVector

# ## `rotate_to_plane` — align a reference direction
#
# **`rotate_to_plane(p, which_z, which_xplus)`** builds the rotation that:
#
# 1. Rotates the spatial direction of **`which_z`** onto lab **$+\hat{z}$** (`Ry`, then `Rz`), and
# 2. Rotates about $z$ so **`which_xplus`** lies in the $x$–$z$ plane with $p_x \ge 0$.
#
# Only the **directions** of the reference four-vectors matter (masses are ignored for the rotation axes).
# Use this when you want a standard frame where a beam or parent defines $z$ and a second vector fixes the $x$–$z$ plane.

which_z = FourVector(0.0, 0.0, 1.0; M = 2.0)
which_xplus = FourVector(1.0, 1.0, 0.0; M = 0.0)

p_plane = rotate_to_plane(p, which_z, which_xplus)
@test p_plane.py ≈ 0.0 atol = 1e-10
@test p_plane.px ≥ 0.0

# ## `transform_to_cmf` — go to another particle’s rest frame
#
# **`transform_to_cmf(p, which_cmf)`** transforms **`p`** into the rest frame of **`which_cmf`**:
# rotate `which_cmf` onto $+\hat{z}$, then boost along $z$ with $\gamma = \gamma(\text{which\_cmf})$ so that `which_cmf` has zero spatial momentum.
#
# This is the frame where the total momentum of a two-body system is zero when `which_cmf` is chosen as one of the participants or as the total four-momentum.

beam = FourVector(1.0, 0.0, 0.0; E = 2.0)
p_cmf = transform_to_cmf(p, beam)
@test p_cmf isa FourVector

(collect(p), collect(p_ry), collect(p_boosted), collect(p_plane), collect(p_cmf))
