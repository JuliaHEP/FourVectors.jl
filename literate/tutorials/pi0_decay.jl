# # π⁰ → γ γ in the laboratory
#
# This tutorial walks through a minimal four-momentum exercise for neutral pion decay.
# Photon energies match half the π⁰ mass in the decay frame (`m_pi0/2`), boosted with **`Bz`** into the lab, rotated with **`Ry`** and **`Rz`** so that photon 1 aligns with the parent kinematics (**`spherical_coordinates`**), and complemented by subtraction for photon 2.

using FourVectors
using Test

# ## Mass units and laboratory pion
#
# Approximate π⁰ mass in GeV; lab three-momentum is chosen as a simple illustrative example.

m_pi0 = 0.135
p_pi0 = FourVector(1.0, 1.0, 30.0; M = m_pi0)

# ## Photon 1 — scale (massless proxy), lab boost, rotations to match the parent axis
#
# Pick polar angle `theta_gamma` along `(sin θ, 0, cos θ)`. The factor `m_pi0/2` sets the invariant mass squared to zero for the auxiliary `FourVector`; then apply **`Bz(boost_gamma(p_pi0))`** and rotations using `acos(Omega.cosθ)` and **`Omega.ϕ`** where `Omega = spherical_coordinates(p_pi0)` encodes the pion pointing direction.

theta_gamma = 0.3
Omega = spherical_coordinates(p_pi0)

p_gamma1 =
    let
        p = (m_pi0 / 2) * FourVector(sin(theta_gamma), 0.0, cos(theta_gamma); E = 1.0)
        p |> Bz(boost_gamma(p_pi0)) |> Ry(acos(Omega.cosθ)) |> Rz(Omega.ϕ)
    end

# Photon 2 restores four-momentum: `p_gamma1 + p_gamma2 ≈ p_pi0`.

p_gamma2 = p_pi0 - p_gamma1

@test mass2(p_gamma1) < 1e-10
@test mass2(p_gamma2) < 1e-10
@test mass(p_gamma1 + p_gamma2) ≈ mass(p_pi0)
@test p_gamma1 + p_gamma2 ≈ p_pi0

# ## Quick inspection

(collect(p_pi0), collect(p_gamma1), collect(p_gamma2))
