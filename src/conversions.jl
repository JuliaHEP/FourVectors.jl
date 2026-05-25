function FourVector(v::FourVectorCyl{T}) where {T}
    px1 = v.pt * cos(v.phi)
    py1 = v.pt * sin(v.phi)
    pz1 = v.pt * sinh(v.eta)
    return FourVector(px1, py1, pz1; M = v.mass)
end

function FourVectorCyl(v::FourVector{T}) where {T}
    return FourVectorCyl(
        transverse_momentum(v),
        pseudorapidity(v),
        azimuthal_angle(v),
        mass(v),
    )
end
