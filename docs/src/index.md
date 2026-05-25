# FourVectors.jl

[FourVectors](https://github.com/JuliaHEP/FourVectors.jl) wraps an immutable Cartesian four-momentum (**`FourVector`** as **`FieldVector{4}`**) and implements the **[LorentzVectorBase.jl](https://github.com/JuliaHEP/LorentzVectorBase.jl)** interface.

Installation, exported kinematic accessors, and usage examples appear in the README on GitHub (`README.md`).

## Tutorials

Step-by-step guides (executed when the manual is built):

1. [Creating and accessing](tutorials/creation_and_access.md) — construction, fields, indexing, accessors and aliases
2. [Algebra](tutorials/algebra.md) — `+`, `-`, scalar `*`, Minkowski `dot`
3. [Transformations](tutorials/transformations.md) — rotations, boosts, `rotate_to_plane`, `transform_to_cmf`
4. [Neutral pion decay](tutorials/pi0_decay.md) — worked decay example combining the above

Sources live under [`literate/tutorials/`](https://github.com/JuliaHEP/FourVectors.jl/tree/main/literate/tutorials/) and are woven into this manual with **[Literate.jl](https://github.com/fredrikekre/Literate.jl)** during **`docs/make.jl`**.
