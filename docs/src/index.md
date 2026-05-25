# FourVectors.jl

[FourVectors](https://github.com/mmikhasenko/FourVectors.jl) provides immutable **concrete** four-momentum types — **`FourVector`** (Cartesian) and **`FourVectorCyl`** (cylindrical) — as **`FieldVector{4}`** implementations of the **[LorentzVectorBase.jl](https://github.com/JuliaHEP/LorentzVectorBase.jl)** interface.

Load both packages in typical use:

```julia
using FourVectors, LorentzVectorBase
```

Installation, usage, and Lorentz transforms appear in the README on GitHub (`README.md`).

## Guides

See [Neutral pion decay](tutorials/pi0_decay.md).

Source Julia script: [`literate/tutorials/pi0_decay.jl`](https://github.com/mmikhasenko/FourVectors.jl/blob/main/literate/tutorials/pi0_decay.jl).
It is bundled into this manual with **[Literate.jl](https://github.com/fredrikekre/Literate.jl)** and its code chunks are executed during **`docs/make.jl`** when the manual is built.
