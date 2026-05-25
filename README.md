# FourVectors

[![Test workflow status](https://github.com/mmikhasenko/FourVectors.jl/actions/workflows/Test.yml/badge.svg?branch=main)](https://github.com/mmikhasenko/FourVectors.jl/actions/workflows/Test.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/mmikhasenko/FourVectors.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/mmikhasenko/FourVectors.jl)

FourVectors.jl provides an immutable [`FieldVector{4,T}`](https://juliaarrays.github.io/StaticArrays.jl/stable/pages/api/#StaticArrays.FieldVector) type `FourVector` (components `px`, `py`, `pz`, `E` in Cartesian coordinates).

It plugs into **[LorentzVectorBase.jl](https://github.com/JuliaHEP/LorentzVectorBase.jl)** for kinematic accessors. Subtyping `FieldVector` yields `AbstractVector`/`AbstractArray` behavior: indexing (`p[1:3]`), iteration, broadcasting, etc.

## Installation

The package is not registered yet.
Install it with:

```julia
julia> ] add https://github.com/mmikhasenko/FourVectors.jl
```

## Usage

```julia
using FourVectors
```

### Creating `FourVector`s

Specify three-momentum `(px, py, pz)` and **exactly one** of energy `E` or mass `M` (invariant):

```julia
p = FourVector(1.0, 2.0, 3.0; E = 4.0)
p = FourVector(1.0, 2.0, 3.0; M = sqrt(2))
```

### Components

```julia
px = p.px
py = p.py
pz = p.pz
E  = p.E
```

Indexing:

```julia
px = p[1]
py = p[2]
pz = p[3]
E  = p[4]

momentum = p[1:3]  # e.g. [px, py, pz]
```

### Exported kinematic accessors (LorentzVectorBase)

Issue [#14](https://github.com/mmikhasenko/FourVectors.jl/issues/14): this package explicitly **re-exports** the following accessors from LorentzVectorBase (same names after `using FourVectors`):

| Exported name |
| --- |
| `transverse_momentum`, `spatial_magnitude`, `mass`, `mass2` |
| `boost_beta`, `boost_gamma`, `rapidity`, `polar_angle` |
| `cos_theta`, `cos_phi`, `sin_phi`, `azimuthal_angle`, `pseudorapidity` |

Example:

```julia
m      = mass(p)
pt     = transverse_momentum(p)
eta_pr = pseudorapidity(p)
phi    = azimuthal_angle(p)
θ      = polar_angle(p)
```

LorentzVectorBase defines shorter **aliases** (not exported here) — for instance `transverse_momentum(p) ≡ LorentzVectorBase.pt(p)`, `azimuthal_angle(p) ≡ LorentzVectorBase.phi(p)`, and `pseudorapidity(p) ≡ LorentzVectorBase.eta(p)`.
See LorentzVectorBase’s [*What You Get Automatically*](https://github.com/JuliaHEP/LorentzVectorBase.jl/blob/main/docs/src/10-interface.md) for Cartesian components (`px`, …, spatial `x`/`y`/`z` when applicable), invariant and transverse masses, aliases like `energy` / `invariant_mass`, and light-cone coordinates (`plus_component`, `minus_component`).
Call any non-exported method as `LorentzVectorBase.name(p)`, or extend this package using the same `@eval import … export …` pattern used in [`src/FourVectors.jl`](src/FourVectors.jl).

This package additionally exports **`spherical_coordinates`** (returns `(cosθ, ϕ)` for the spatial direction).

### Lorentz transformations

**Exported:** `Rx`, `Ry`, `Rz`, `Bz`, `transform_to_cmf`, `rotate_to_plane`.

Rotations (`Rx`, `Ry`, `Rz`) are active: angle `α` / `θ` / `ϕ` about lab **x**, **y**, **z**.

```julia
p_rx = Rx(p, α)
p_ry = Ry(p, θ)
p_rz = Rz(p, ϕ)
```

Boost along lab **z** with Lorentz factor `γ` (flip sign for the opposite longitudinal direction):

```julia
p_bz = Bz(p, γ)
```

Partial application for pipelines (`p |> Rx(ϕ)`, etc.) is supported.

## Contributing

Contributions are welcome! Issues and PRs belong on GitHub.

## License

This package is released under the MIT License.
