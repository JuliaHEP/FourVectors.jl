"""
    Rx(p::FourVector{T}, α::T) where {T}

Applies an active rotation by angle `α` about the x-axis to `p`.
"""
function Rx(p::FourVector{T}, α::T) where {T}
    sinα, cosα = sincos(α)
    new_py = p.py * cosα - p.pz * sinα
    new_pz = p.py * sinα + p.pz * cosα
    return FourVector{T}(p.px, new_py, new_pz, p.E)
end

"""
    Ry(p::FourVector{T}, θ::T) where {T}

Applies an active rotation by angle `θ` about the y-axis to `p`.
"""
function Ry(p::FourVector{T}, θ::T) where {T}
    sinθ, cosθ = sincos(θ)
    new_pz = p.pz * cosθ - p.px * sinθ
    new_px = p.pz * sinθ + p.px * cosθ
    return FourVector{T}(new_px, p.py, new_pz, p.E)
end

"""
    Rz(p::FourVector{T}, ϕ::T) where {T}

Applies an active rotation by angle `ϕ` about the z-axis to `p`.
"""
function Rz(p::FourVector{T}, ϕ::T) where {T}
    sinϕ, cosϕ = sincos(ϕ)
    new_px = p.px * cosϕ - p.py * sinϕ
    new_py = p.px * sinϕ + p.py * cosϕ
    return FourVector{T}(new_px, new_py, p.pz, p.E)
end

"""
    Bz(p::FourVector{T}, γ::T) where {T}

Applies an active boost along the z-axis with Lorentz factor `γ`.
A negative `γ` reverses the boost direction (same `|γ|`, opposite sign of longitudinal velocity).
"""
function Bz(p::FourVector{T}, γ::T) where {T}
    _γ = abs(γ)
    _βγ = sqrt(γ^2 - 1) * sign(γ)
    #
    new_pz = _γ * p.pz + _βγ * p.E
    new_E = _γ * p.E + _βγ * p.pz
    return FourVector{T}(p.px, p.py, new_pz, new_E)
end

# functors
Rx(ϕ) = p -> Rx(p, ϕ)
Ry(ϕ) = p -> Ry(p, ϕ)
Rz(ϕ) = p -> Rz(p, ϕ)
Bz(γ) = p -> Bz(p, γ)

"""
    rotate_to_plane(p, which_z, which_xplus)

Rotates a four-momentum `p` into a reference frame where the **z**-axis follows `which_z`
and where the spatial direction `which_xplus` fixes azimuth (`φ` > 0 half-plane).

Sequence:

1. Rotate so `which_z` aligns with the lab **+z** (`Ry`, `Rz`).
2. Rotate about **z** so `which_xplus` sits in the *x–z* plane at non-negative **x**.

# Example

```julia
julia> p = FourVector(0.5, 0.5, 0.5; M = 1.0);

julia> which_z = FourVector(0.0, 0.0, 1.0; M = 2.0);

julia> which_xplus = FourVector(1.0, 1.0, 0.0; M = 0.0);

julia> rotate_to_plane(p, which_z, which_xplus)
4-element FourVector{Float64} with indices SOneTo(4):
 0.7071067811865475
 5.551115123125783e-17
 0.5
 1.3228756555322954
```
"""
function rotate_to_plane(p, which_z, which_xplus)
    θb = polar_angle(which_z)
    ϕb = azimuthal_angle(which_z)
    ϕt = azimuthal_angle(which_xplus |> Rz(-ϕb) |> Ry(-θb))
    p |> Rz(-ϕb) |> Ry(-θb) |> Rz(-ϕt)
end

"""
    transform_to_cmf(p, which_cmf)

Transforms `p` into the center-of-momentum frame of `which_cmf`: rotate so its
spatial direction aligns with **+z**, then boost along **z** using the Lorentz factor of `which_cmf`.

# Example

```julia
julia> p = FourVector(0.5, 0.5, 0.5; M = 1.0);

julia> transform_to_cmf(p, FourVector(1.0, 0.0, 0.0; E = 2.0))
4-element FourVector{Float64} with indices SOneTo(4):
 -0.49999999999999994
  0.5
 -0.18641234663634787
  1.238850097057134
```
"""
function transform_to_cmf(p, which_cmf)
    pR = which_cmf
    θ = polar_angle(pR)
    ϕ = azimuthal_angle(pR)
    γ = boost_gamma(pR)

    # Apply rotation and boost transformations
    p |> Rz(-ϕ) |> Ry(-θ) |> Bz(-γ)
end
