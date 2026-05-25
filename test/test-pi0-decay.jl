using FourVectors
using Test

@testset "π⁰ decay (literate tutorial source)" begin
    include(normpath(joinpath(@__DIR__, "..", "literate", "tutorials", "pi0_decay.jl")))
end
