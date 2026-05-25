struct FourVector{T} <: FieldVector{4, T}
    px::T
    py::T
    pz::T
    E::T
end

function FourVector(
    px::T,
    py::T,
    pz::T;
    E::Union{Nothing, T} = nothing,
    M::Union{Nothing, T} = nothing,
) where {T}
    if (E === nothing) == (M === nothing)
        throw(ArgumentError("Must specify exactly one of `E` or `M`."))
    end

    if E !== nothing
        return FourVector{T}(px, py, pz, E)
    else
        E_calculated = sqrt(px^2 + py^2 + pz^2 + M^2)
        return FourVector{T}(px, py, pz, E_calculated)
    end
end

FourVector(p::NTuple{4, T}) where {T} = FourVector{T}(p...)
FourVector(p::AbstractVector{T}) where {T} = FourVector{T}(p...)

LorentzVectorBase.coordinate_system(::FourVector) = LorentzVectorBase.PxPyPzE()
LorentzVectorBase.px(mom::FourVector) = getfield(mom, :px)
LorentzVectorBase.py(mom::FourVector) = getfield(mom, :py)
LorentzVectorBase.pz(mom::FourVector) = getfield(mom, :pz)
LorentzVectorBase.E(mom::FourVector) = getfield(mom, :E)

LinearAlgebra.dot(p1::FourVector, p2::FourVector) = p1.E * p2.E - dot(p1.P, p2.P)

"""
    spherical_coordinates(p)

Polar direction of spatial part of `p` as `(cosθ = cos_theta(p), ϕ = azimuthal_angle(p))`.
"""
spherical_coordinates(p) = (cosθ = cos_theta(p), ϕ = azimuthal_angle(p))
