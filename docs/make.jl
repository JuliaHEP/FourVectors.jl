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

const TUTORIAL_PAGES = [
    "Creating and accessing" => "creation_and_access",
    "Algebra" => "algebra",
    "Transformations" => "transformations",
    "Neutral pion decay" => "pi0_decay",
]

for (_, name) in TUTORIAL_PAGES
    Literate.markdown(
        joinpath(LITERATE_SRC, "$(name).jl"),
        GENERATED_MD;
        name,
        credit = false,
        documenter = true,
        execute = true,
    )
end

makedocs(;
    sitename = "FourVectors.jl",
    authors = "Misha Mikhasenko and contributors.",
    format = Documenter.HTML(; prettyurls = get(ENV, "CI", "false") == "true"),
    modules = [FourVectors],
    linkcheck = true,
    linkcheck_ignore = [
        # GitHub blob URLs rate-limit anonymous curl requests during linkcheck.
        r"^https://github.com/JuliaHEP/FourVectors.jl/blob/",
    ],
    pages = [
        "Home" => "index.md",
        "Tutorials" => [title => joinpath("tutorials", "$name.md") for (title, name) in TUTORIAL_PAGES],
        "API reference" => "reference.md",
    ],
)

deploydocs(;
    repo = "github.com/JuliaHEP/FourVectors.jl.git",
    devbranch = "main",
    versions = ["dev" => "dev"],
)
