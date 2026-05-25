# FourVectors.jl

[FourVectors](https://github.com/mmikhasenko/FourVectors.jl) wraps an immutable Cartesian four-momentum (**`FourVector`** as **`FieldVector{4}`**) and implements the **[LorentzVectorBase.jl](https://github.com/JuliaHEP/LorentzVectorBase.jl)** interface.

Installation, exported kinematic accessors, and usage examples appear in the README on GitHub (`README.md`).

## Guides

See [Neutral pion decay](tutorials/pi0_decay.md).

Source Julia script: [`literate/tutorials/pi0_decay.jl`](https://github.com/mmikhasenko/FourVectors.jl/blob/main/literate/tutorials/pi0_decay.jl).
It is bundled into this manual with **[Literate.jl](https://github.com/fredrikekre/Literate.jl)** (`docs/make.jl`) and exercised by **`Pkg.test()`** via `include`.
