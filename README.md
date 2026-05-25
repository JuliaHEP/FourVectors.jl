# FourVectors

[![Test workflow status](https://github.com/mmikhasenko/FourVectors.jl/actions/workflows/Test.yml/badge.svg?branch=main)](https://github.com/mmikhasenko/FourVectors.jl/actions/workflows/Test.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/mmikhasenko/FourVectors.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/mmikhasenko/FourVectors.jl)
[![Docs](https://img.shields.io/badge/docs-blue.svg)](https://mmikhasenko.github.io/FourVectors.jl/dev/)

FourVectors.jl provides immutable [`FieldVector{4,T}`](https://juliaarrays.github.io/StaticArrays.jl/stable/pages/api/#StaticArrays.FieldVector) types for four-momenta:

- **`FourVector`** — Cartesian `(px, py, pz, E)`
- **`FourVectorCyl`** — cylindrical `(pt, η, φ, M)` as used at colliders

Both implement the **[LorentzVectorBase.jl](https://github.com/JuliaHEP/LorentzVectorBase.jl)** interface; this package re-exports the kinematic accessors and collider utilities most users need after `using FourVectors`. Subtyping `FieldVector` yields `AbstractVector`/`AbstractArray` behavior: indexing, iteration, broadcasting, etc.

## Installation

The package is not registered yet.
Install it with:

```julia
julia> ] add https://github.com/mmikhasenko/FourVectors.jl
```

## Documentation

**[Documentation](https://mmikhasenko.github.io/FourVectors.jl/dev/)** (`main` → `gh-pages` `/dev/`): navigable API reference (`@autodocs`) and **[π⁰ → γ γ tutorial](https://mmikhasenko.github.io/FourVectors.jl/dev/tutorials/pi0_decay/)**.

The tutorial source is plain Julia at [`literate/tutorials/pi0_decay.jl`](https://github.com/mmikhasenko/FourVectors.jl/blob/main/literate/tutorials/pi0_decay.jl); [Literate.jl](https://github.com/fredrikekre/Literate.jl) turns it into a documentation page and runs the embedded code when the docs build executes **`docs/make.jl`** (see **`.github/workflows/Documentation.yml`** in this repository).

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

### Exported kinematic accessors (from LorentzVectorBase)

This package **re-exports** accessors from LorentzVectorBase (same names after `using FourVectors`):

| Exported name |
| --- |
| `transverse_momentum`, `spatial_magnitude`, `mass`, `mass2` |
| `boost_beta`, `boost_gamma`, `rapidity`, `polar_angle` |
| `cos_theta`, `cos_phi`, `sin_phi`, `azimuthal_angle`, `pseudorapidity` |
| `transverse_mass`, `transverse_mass2`, `pt`, `pt2`, `eta`, `phi`, `mt`, `mt2` |
| `px`, `py`, `pz`, `energy` |

Example:

```julia
m      = mass(p)
pt     = transverse_momentum(p)  # same as pt(p)
eta_pr = pseudorapidity(p)       # same as eta(p)
phi    = azimuthal_angle(p)      # same as phi(p)
θ      = polar_angle(p)
```

Additional LorentzVectorBase methods (light-cone components, etc.) remain available as `LorentzVectorBase.name(p)`.
See [*What You Get Automatically*](https://github.com/JuliaHEP/LorentzVectorBase.jl/blob/main/docs/src/10-interface.md).

This package additionally exports **`spherical_coordinates`** (returns `(cosθ, ϕ)` for the spatial direction).

### Cylindrical `FourVectorCyl`

Native collider coordinates `(pt, η, φ, M)`:

```julia
v = FourVectorCyl(43.7, 1.47, 1.69, 0.106)
p = FourVector(v)   # convert to Cartesian
c = FourVectorCyl(p)
```

Also exported:

- **`fromPtEtaPhiE`** — build from `(pt, η, φ, E)`
- **`+`** on `FourVectorCyl` — sum four-momenta and recompute kinematics
- **`fast_mass`** — optimized di-mass for two cylindrical vectors
- **`deltar`**, **`deltaphi`**, **`deltaeta`** (aliases **`ΔR`**, **`Δϕ`**, **`Δη`**) on both `FourVector` and `FourVectorCyl`

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

## Related packages

FourVectors.jl builds on the shared interface in **[LorentzVectorBase.jl](https://github.com/JuliaHEP/LorentzVectorBase.jl)** and provides concrete `FieldVector` types with Lorentz transforms and collider utilities.

Other Lorentz-vector packages in the Julia ecosystem:

- **[LorentzVectorHEP.jl](https://github.com/JuliaHEP/LorentzVectorHEP.jl)** — Cartesian `(t, x, y, z)` and cylindrical `(pt, η, φ, M)` types for collider-style kinematics (`ΔR`, `fast_mass`, …). `FourVectorCyl` covers much of the same cylindrical workflow; see [JuliaHEP/LorentzVectorBase.jl#43](https://github.com/JuliaHEP/LorentzVectorBase.jl/issues/43) for planned shared separation utilities upstream.
- **[LorentzVectors.jl](https://github.com/JLTastet/LorentzVectors.jl)** — general-purpose `LorentzVector` / `MinkowskiVector` types and operations in special relativity.

## Contributing

Contributions are welcome! Issues and PRs belong on GitHub.

## License

This package is released under the MIT License.
