# FourVectors

[![Test workflow status](https://github.com/mmikhasenko/FourVectors.jl/actions/workflows/Test.yml/badge.svg?branch=main)](https://github.com/mmikhasenko/FourVectors.jl/actions/workflows/Test.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/mmikhasenko/FourVectors.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/mmikhasenko/FourVectors.jl)
[![Docs](https://img.shields.io/badge/docs-blue.svg)](https://mmikhasenko.github.io/FourVectors.jl/dev/)

FourVectors.jl is a small package for Cartesian four-momenta in high-energy physics.
The central type is `FourVector`, an immutable `FieldVector{4}` from StaticArrays with named components `px`, `py`, `pz`, and `E`.

Because `FourVector` subtypes `FieldVector`, it behaves like a normal Julia vector: you can index it (`p[1]`, `p[1:3]`), iterate over it, broadcast, and pass it anywhere an `AbstractVector` is expected.
The spatial three-momentum is available as a slice, `p[1:3]`, without extra wrappers.

The type implements the [LorentzVectorBase.jl](https://github.com/JuliaHEP/LorentzVectorBase.jl) interface, so kinematic quantities such as invariant mass, transverse momentum, and pseudorapidity are computed through shared accessors.
A subset of those accessors is re-exported from this module; see below.

## Related packages

Julia already has several Lorentz-vector libraries.
Two that are often used in HEP workflows are:

- [LorentzVectors.jl](https://github.com/JLTastet/LorentzVectors.jl) — lightweight, registered package with `LorentzVector` / `Vec4` and `SpatialVector` / `Vec3`, Minkowski inner products, boosts, and related algebra.
- [LorentzVectorHEP.jl](https://github.com/JuliaHEP/LorentzVectorHEP.jl) — HEP-oriented layer built on LorentzVectors.jl, adding cylindrical coordinates (`LorentzVectorCyl`) and common analysis helpers (`ΔR`, `mt`, and similar).

## Installation

The package is not registered yet.
Install from GitHub:

```julia
julia> ] add https://github.com/mmikhasenko/FourVectors.jl
```

## Documentation

Full API reference and tutorials are on the [Documenter site](https://mmikhasenko.github.io/FourVectors.jl/dev/).

Tutorials are plain Julia scripts in `literate/tutorials/` and woven into the manual with Literate.jl when the docs build runs `docs/make.jl`.

## Usage

```julia
using FourVectors
```

### Creating four-vectors

Give three-momentum `(px, py, pz)` and exactly one of energy `E` or invariant mass `M`:

```julia
p = FourVector(1.0, 2.0, 3.0; E = 4.0)
p = FourVector(1.0, 2.0, 3.0; M = sqrt(2))
```

### Components and indexing

Named fields:

```julia
px = p.px
py = p.py
pz = p.pz
E  = p.E
```

Integer indexing follows `(px, py, pz, E)`:

```julia
px = p[1]
py = p[2]
pz = p[3]
E  = p[4]

momentum = p[1:3]   # spatial part as a 3-vector
```

### Kinematic accessors

After `using FourVectors`, these LorentzVectorBase functions are exported:

| Name |
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

LorentzVectorBase also provides shorter aliases (`pt`, `phi`, `eta`, and others) and additional methods (light-cone components, transverse mass, and more).
Those are available as `LorentzVectorBase.name(p)` unless you import them yourself.
See the LorentzVectorBase documentation for the full interface.

This package additionally exports `spherical_coordinates`, which returns a named tuple `(cosθ, ϕ)` for the spatial direction.

### Lorentz transformations

Exported transforms: `Rx`, `Ry`, `Rz`, `Bz`, `transform_to_cmf`, `rotate_to_plane`.

Rotations are active rotations about the lab x, y, and z axes:

```julia
p_rx = Rx(p, α)
p_ry = Ry(p, θ)
p_rz = Rz(p, ϕ)
```

Longitudinal boost along lab z with Lorentz factor `γ` (flip the sign of `γ` for the opposite direction):

```julia
p_bz = Bz(p, γ)
```

Partial application works in pipelines, e.g. `p |> Rx(ϕ)`.

## Contributing

Contributions are welcome — please open issues or pull requests on GitHub.

## License

MIT License.
