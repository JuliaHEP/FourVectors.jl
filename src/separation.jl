"""
    fromPtEtaPhiE(pt, eta, phi, E)

Build a [`FourVectorCyl`](@ref) from transverse momentum, pseudorapidity, azimuth, and energy.
Mass is inferred from the on-shell relation ``m^2 = E^2 - p_T^2 - p_z^2``.
"""
function fromPtEtaPhiE(pt, eta, phi, E)
    pt, eta, phi, E = promote(pt, eta, phi, E)
    m2 = E^2 - pt^2 - (sinh(eta) * pt)^2
    m = sign(m2) * sqrt(abs(m2))
    return FourVectorCyl(pt, eta, phi, m)
end

"""
    fast_mass(v1, v2)

Invariant mass of two [`FourVectorCyl`](@ref)s without forming intermediate `(pt, η, φ)` for the sum.
Equivalent to `(v1 + v2).mass` but faster.
"""
function fast_mass(v1::FourVectorCyl, v2::FourVectorCyl)
    pt1, pt2 = v1.pt, v2.pt
    eta1, eta2 = v1.eta, v2.eta
    phi1, phi2 = v1.phi, v2.phi
    m1, m2 = v1.mass, v2.mass

    sinheta1 = sinh(eta1)
    sinheta2 = sinh(eta2)
    tpt12 = 2 * pt1 * pt2
    return @fastmath sqrt(
        max(
            fma(m1, m1, m2^2) +
            2 * sqrt((pt1^2 * (1 + sinheta1^2) + m1^2) * (pt2^2 * (1 + sinheta2^2) + m2^2)) -
            tpt12 * sinheta1 * sinheta2 -
            tpt12 * cos(phi1 - phi2),
            zero(pt1),
        ),
    )
end

@inline function phi_mpi_pi(x)
    twopi = 2pi
    while x >= pi
        x -= twopi
    end
    while x < -pi
        x += twopi
    end
    return x
end

@inline deltaphi(v1, v2) = phi_mpi_pi(LorentzVectorBase.phi(v1) - LorentzVectorBase.phi(v2))
@inline deltaeta(v1, v2) = LorentzVectorBase.eta(v1) - LorentzVectorBase.eta(v2)

@inline function deltar2(v1, v2)
    dϕ = deltaphi(v1, v2)
    dη = deltaeta(v1, v2)
    return muladd(dϕ, dϕ, dη^2)
end

deltar(v1, v2) = sqrt(deltar2(v1, v2))

const Δϕ = deltaphi
const Δη = deltaeta
const ΔR = deltar
