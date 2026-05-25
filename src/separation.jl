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

"""
    deltaphi(v1, v2)

Azimuthal separation ``\\Delta\\phi`` in ``[-\\pi, \\pi)``, using `phi(v1) - phi(v2)`.
"""
@inline deltaphi(v1, v2) = phi_mpi_pi(LorentzVectorBase.phi(v1) - LorentzVectorBase.phi(v2))

"""
    deltaeta(v1, v2)

Pseudorapidity separation ``\\Delta\\eta = \\eta(v_1) - \\eta(v_2)``.
"""
@inline deltaeta(v1, v2) = LorentzVectorBase.eta(v1) - LorentzVectorBase.eta(v2)

"""
    deltar2(v1, v2)

Squared separation ``\\Delta R^2 = (\\Delta\\eta)^2 + (\\Delta\\phi)^2`` in the ``\\eta\\!-\\!\\phi`` plane.
"""
@inline function deltar2(v1, v2)
    dϕ = deltaphi(v1, v2)
    dη = deltaeta(v1, v2)
    return muladd(dϕ, dϕ, dη^2)
end

"""
    deltar(v1, v2)

Separation ``\\Delta R = \\sqrt{(\\Delta\\eta)^2 + (\\Delta\\phi)^2}`` in the ``\\eta\\!-\\!\\phi`` plane.
"""
deltar(v1, v2) = sqrt(deltar2(v1, v2))

const Δϕ = deltaphi
const Δη = deltaeta
const ΔR = deltar
