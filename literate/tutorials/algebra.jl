# # Algebra of four-vectors
#
# Four-momentum is conserved as a **four-vector**, not as separate sums of energy and three-momentum in an arbitrary frame.
# Because **`FourVector`** subtypes **`FieldVector{4}`**, Julia’s `+`, `-`, and scalar `*` act component-wise —
# exactly what you need for building total momenta, decay kinematics, and linear combinations in matrix elements.
#
# The Minkowski inner product (invariant scalar product) is **`dot`**, with the same $(+,-,-,-)$ signature as the mass formula.

using FourVectors
using LinearAlgebra
using Test

p = FourVector(10.0, 0.0, 0.0; E = 11.0)   # nearly collinear with +x
q = FourVector(-3.0, 1.0, 2.0; M = 2.0)    # on-shell particle of mass 2

# ## Addition and subtraction
#
# **`p + q`** adds each component: $(p+q)^\mu = p^\mu + q^\mu$.
# In a decay or splitting $P \to p_1 + p_2 + \cdots$, momentum conservation reads $\sum_i p_i^\mu = P^\mu$.
#
# **Important:** $m(P) \neq m(p_1) + m(p_2)$ in general.
# Only the **invariant** $m^2 = p\cdot p$ is computed from the full four-vector; adding masses is not meaningful physics.

sum_pq = p + q
diff_pq = p - q

@test sum_pq.px ≈ p.px + q.px
@test sum_pq.E ≈ p.E + q.E
@test diff_pq ≈ p - q
@test (p - q) + q ≈ p

# Typical pattern: one daughter is reconstructed, the other is inferred by subtraction in the **same frame**:

parent = FourVector(1.0, 1.0, 30.0; M = 0.135)   # e.g. π⁰ in GeV
daughter = FourVector(0.2, 0.1, 5.0; E = 5.01)   # photon or track candidate
other = parent - daughter

@test parent ≈ daughter + other

# Here `other` is the four-momentum of the complementary system; it is on-shell only if `daughter` was exact.

# ## Scalar multiplication
#
# Multiplying by a real number scales **all** components.
# A common trick for massless particles is to start from a light-like direction $(\hat{n}, 1)$ in arbitrary units
# and multiply by an energy scale so that $m^2 \approx 0$ after boosts (see the π⁰ decay tutorial).

scaled = 0.5 * parent
@test scaled.px ≈ 0.5 * parent.px
@test scaled.E ≈ 0.5 * parent.E
@test parent * 2 ≈ 2 * parent

# ## Minkowski inner product
#
# **`dot(p, q) = E_1 E_2 - \vec{p}_1\cdot\vec{p}_2`** (ordinary Euclidean dot for the spatial parts).
# For one four-vector, **`dot(p, p) = m^2(p)`** — this is the on-shell condition checker.
#
# The product is **Lorentz invariant**: the same number in every inertial frame, unlike $E$ or $p_z$ alone.

@test dot(p, p) ≈ mass2(p)
@test dot(p, q) ≈ p.E * q.E - (p.px * q.px + p.py * q.py + p.pz * q.pz)

# Illustration: reconstructing the parent mass from a sum of daughters only works when the daughters sum to the parent four-vector.

(mass(parent), mass(daughter + other), dot(parent, parent), scaled.E)
