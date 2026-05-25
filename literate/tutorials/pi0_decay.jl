# # π⁰ → γ γ in the laboratory
#
# A compact end-to-end example that combines construction, algebra, and transformations.
# We model $\pi^0 \to \gamma\gamma$ in the lab: the parent pion has mass $m_{\pi^0}$ and a finite lab momentum;
# each photon is massless ($m_\gamma = 0$).
#
# Strategy:
#
# 1. Build photon 1 in a frame where its direction is simple, with a **light-like proxy** scaled to energy $m_{\pi^0}/2$ in the π⁰ rest frame.
# 2. **Boost** to the lab with **`Bz(boost_gamma(p_pi0))`**.
# 3. **Rotate** with **`Ry`** and **`Rz`** so the kinematics align with the parent’s polar axis (**`spherical_coordinates`**).
# 4. Obtain photon 2 by **four-momentum subtraction** — momentum conservation in the lab.

using FourVectors
using Test

# ## Parent pion in the lab
#
# Mass in GeV (PDG value is $\approx 135\,\mathrm{MeV}$); spatial components are illustrative lab momentum.

m_pi0 = 0.135
p_pi0 = FourVector(1.0, 1.0, 30.0; M = m_pi0)

# ## Photon 1: decay frame → lab → parent axis
#
# In the π⁰ rest frame the two photons are back-to-back with energy $E_\gamma = m_{\pi^0}/2$.
# We start from a unit direction $(\sin\theta_\gamma, 0, \cos\theta_\gamma)$ with $E=1$, then multiply by $m_{\pi^0}/2$
# so that $m^2 = E^2 - |\vec{p}|^2 \approx 0$ for this proxy four-vector.
#
# **`Bz(boost_gamma(p_pi0))`** takes the configuration to the lab frame along the pion’s boost.
# **`Ry(acos(Ω.cosθ))`** and **`Rz(Ω.ϕ)`** with `Ω = spherical_coordinates(p_pi0)` align the decay plane with the parent direction.

theta_gamma = 0.3
Omega = spherical_coordinates(p_pi0)

p_gamma1 =
    let
        p = (m_pi0 / 2) * FourVector(sin(theta_gamma), 0.0, cos(theta_gamma); E = 1.0)
        p |> Bz(boost_gamma(p_pi0)) |> Ry(acos(Omega.cosθ)) |> Rz(Omega.ϕ)
    end

# ## Photon 2 from momentum conservation
#
# In the lab, $\;p_{\pi^0}^\mu = p_{\gamma_1}^\mu + p_{\gamma_2}^\mu\;$, so $p_{\gamma_2} = p_{\pi^0} - p_{\gamma_1}$.
# Both photons should remain light-like ($m^2 \approx 0$), and the sum should reproduce the parent.

p_gamma2 = p_pi0 - p_gamma1

@test mass2(p_gamma1) < 1e-10
@test mass2(p_gamma2) < 1e-10
@test mass(p_gamma1 + p_gamma2) ≈ mass(p_pi0)
@test p_gamma1 + p_gamma2 ≈ p_pi0

# ## Inspect components
#
# Components are $(p_x, p_y, p_z, E)$; the slight mismatch in $m^2$ is at the level of floating-point error after boosts.

(collect(p_pi0), collect(p_gamma1), collect(p_gamma2))
