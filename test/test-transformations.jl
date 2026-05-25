using FourVectors
using Test

p = FourVector(0.5, 0.5, 0.5; M = 1.0);

@testset "Boost and Rotation to CMF" begin
    p′ = transform_to_cmf(p, FourVector(1.0, 0.0, 0.0; E = 2.0))
    @test p′ ≈ [-0.5, 0.5, -0.18641234663634787, 1.238850097057134]
end

which_z = FourVector(0.0, 0.0, 1.0; M = 2.0);
which_xplus = FourVector(1.0, 1.0, 0.0; M = 0.0);

@testset "Rotate to plane" begin
    p′ = rotate_to_plane(p, which_z, which_xplus)
    @test p′ ≈ [0.7071067811865475, 5.551115123125783e-17, 0.5, 1.3228756555322954]
end
