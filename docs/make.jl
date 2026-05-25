import Pkg

const ROOT = dirname(@__DIR__)
Pkg.activate(@__DIR__)
Pkg.develop(path = ROOT)
Pkg.instantiate()

using Documenter
using Literate
using FourVectors

const LITERATE_SRC = joinpath(ROOT, "literate", "tutorials")
const GENERATED_MD = joinpath(@__DIR__, "src", "tutorials")

mkpath(GENERATED_MD)

Literate.markdown(
    joinpath(LITERATE_SRC, "pi0_decay.jl"),
    GENERATED_MD;
    name = "pi0_decay",
    credit = false,
    documenter = true,
    execute = true,
)

makedocs(;
    sitename = "FourVectors.jl",
    authors = "Misha Mikhasenko and contributors.",
    format = Documenter.HTML(; prettyurls = get(ENV, "CI", "false") == "true"),
    modules = [FourVectors],
    pages = [
        "Home" => "index.md",
        "Tutorials" =>
            ["Neutral pion decay" => joinpath("tutorials", "pi0_decay.md")],
        "API reference" => "reference.md",
    ],
)

deploydocs(;
    repo = "github.com/mmikhasenko/FourVectors.jl.git",
    devbranch = "main",
)
