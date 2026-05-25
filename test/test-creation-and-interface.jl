using Test

p = FourVector(1.0, 2.0, 3.0; E = 4.0)
p′ = FourVector(1.0, 2.0, 3.0; M = √2)


@testset "Construction" begin
    @test p isa FourVector
    @test p ≈ p′
    @test_throws ArgumentError FourVector(1, 2, 3)
    @test_throws ArgumentError FourVector(1.0, 2.0, 3.0; E = 3.3, M = 4.0)
end

@testset "Construction with type promotion (px, py, pz versus E/M)" begin
    pI = FourVector(1.0, 1.0, 1.0; E = 2)
    @test pI isa FourVector{Float64}
    @test pI ≈ [1.0, 1.0, 1.0, 2.0]

    pF = FourVector(1, 2, 3; E = 4.0)
    @test pF isa FourVector{Float64}
    @test pF ≈ [1.0, 2.0, 3.0, 4.0]

    pM = FourVector(1, 2, 2; M = 3.0f0)
    @test pM isa FourVector{Float32}
    @test mass(pM) isa Float32
end

@testset "Properties via LorentzVectorBase interface" begin
    @test mass(p) ≈ sqrt(2)
    @test transverse_momentum(p) == sqrt(5)
    @test spatial_magnitude(p) ≈ sqrt(14)
    @test polar_angle(p) ≈ acos(3 / sqrt(14))
    @test azimuthal_angle(p) ≈ atan(2, 1)
    @test cos_theta(p) ≈ 3 / sqrt(14)

    Ω = spherical_coordinates(p)
    @test Ω.cosθ ≈ cos_theta(p)
    @test Ω.ϕ ≈ azimuthal_angle(p)
    @test propertynames(Ω) === (:cosθ, :ϕ)
end
