struct FourVectorCyl{T} <: FieldVector{4, T}
    pt::T
    eta::T
    phi::T
    mass::T
end

FourVectorCyl(pt, eta, phi, mass) = FourVectorCyl(promote(pt, eta, phi, mass)...)
FourVectorCyl(p::NTuple{4, T}) where {T} = FourVectorCyl{T}(p...)
FourVectorCyl(p::AbstractVector{T}) where {T} = FourVectorCyl{T}(p...)

LorentzVectorBase.coordinate_system(::FourVectorCyl) = LorentzVectorBase.PtEtaPhiM()
LorentzVectorBase.pt(v::FourVectorCyl) = getfield(v, :pt)
LorentzVectorBase.eta(v::FourVectorCyl) = getfield(v, :eta)
LorentzVectorBase.phi(v::FourVectorCyl) = getfield(v, :phi)
LorentzVectorBase.mass(v::FourVectorCyl) = getfield(v, :mass)

Base.zero(::Type{FourVectorCyl{T}}) where {T} = FourVectorCyl{T}(zero(T), zero(T), zero(T), zero(T))
Base.zero(::Type{FourVectorCyl}) = zero(FourVectorCyl{Float64})
Base.zero(v::FourVectorCyl) = zero(typeof(v))

function Base.:*(v::FourVectorCyl{T}, k::Real) where {T}
    FourVectorCyl{T}(v.pt * k, v.eta, v.phi, v.mass * k)
end

Base.:*(k::Real, v::FourVectorCyl) = v * k

function Base.:/(v::FourVectorCyl, k::Real)
    v * (one(k) / k)
end

function Base.:+(v1::FourVectorCyl{T}, v2::FourVectorCyl{W}) where {T, W}
    m1 = max(v1.mass, zero(v1.pt))
    m2 = max(v2.mass, zero(v2.pt))

    px1, py1, pz1 = LorentzVectorBase.px(v1), LorentzVectorBase.py(v1), LorentzVectorBase.pz(v1)
    px2, py2, pz2 = LorentzVectorBase.px(v2), LorentzVectorBase.py(v2), LorentzVectorBase.pz(v2)
    e1 = sqrt(px1^2 + py1^2 + pz1^2 + m1^2)
    e2 = sqrt(px2^2 + py2^2 + pz2^2 + m2^2)

    sumpx = px1 + px2
    sumpy = py1 + py2
    sumpz = pz1 + pz2

    ptsq = sumpx^2 + sumpy^2
    pt_sum = sqrt(ptsq)
    eta_sum = asinh(sumpz / pt_sum)
    phi_sum = atan(sumpy, sumpx)
    inv_mass = sqrt(
        max(
            muladd(m1, m1, m2^2) + 2 * e1 * e2 -
            2 * (muladd(px1, px2, py1 * py2) + pz1 * pz2),
            zero(v1.pt),
        ),
    )
    return FourVectorCyl(pt_sum, eta_sum, phi_sum, inv_mass)
end

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
