using Test

@testset "FourVectorCyl construction and LorentzVectorBase interface" begin
    v = FourVectorCyl(1761.65, -2.30322, -2.5127, 0.105652)
    @test v isa FourVectorCyl
    @test v.pt == 1761.65
    @test v[1] == v.pt
    @test v[2] == v.eta
    @test v[3] == v.phi
    @test v[4] == v.mass

    @test energy(v) ≈ 8901.870789524375 atol = 1e-6
    @test px(v) ≈ -1424.610065192358 atol = 1e-6
    @test py(v) ≈ -1036.2899616674022 atol = 1e-6
    @test pz(v) ≈ -8725.817601790963 atol = 1e-6
    @test rapidity(v) ≈ -2.3032199982371715 atol = 1e-6

    @test pt2(v) ≈ 3.1034107225e6 atol = 1e-6
    @test mass2(v) ≈ 0.011162345103999998 atol = 1e-6
    @test mt2(v) ≈ 3.103410733662337e6 atol = 1e-6
    @test mt(v) ≈ 1761.650003 atol = 1e-6
end

@testset "FourVectorCyl arithmetic and fast_mass" begin
    v1 = FourVectorCyl(1761.65, -2.30322, -2.5127, 0.105652)
    v2 = FourVectorCyl(115.906, -2.28564, -2.50781, 0.105713)

    @test isapprox((v1 + v2).mass, 8.25741602000877, atol = 1e-6)
    @test isapprox(fast_mass(v1, v2), 8.25741602000877, atol = 1e-6)

    v3 = FourVectorCyl(43.71242f0, 1.4733887f0, 1.6855469f0, 0.10571289f0)
    v4 = FourVectorCyl(36.994347f0, 0.38684082f0, -1.3935547f0, 0.10571289f0)
    @test (v3 + v4).mass == 92.55651f0
    @test fast_mass(v3, v4) ≈ 92.55651f0

    if isdefined(Main, :deltar)
        @test isapprox(deltar(v3, v4), 3.265188f0, atol = 1e-6)
        @test isapprox(deltaphi(v3, v4), 3.0791016f0, atol = 1e-6)
    end

    v5 = v3 * 5
    @test v5.pt == 5 * v3.pt
    @test v5.mass == 5 * v3.mass
    @test v5.eta == v3.eta
    @test v5.phi == v3.phi

    vs = [v1, v2, v3, v4]
    @test sum(vs).mass ≈ 2153.511000993
    @test sum(FourVectorCyl[]).mass ≈ 0
end

@testset "FourVectorCyl conversions" begin
    v1 = FourVectorCyl(1761.65, -2.30322, -2.5127, 0.105652)
    v2 = FourVectorCyl(FourVector(v1))
    @test v1.pt ≈ v2.pt
    @test v1.eta ≈ v2.eta
    @test v1.phi ≈ v2.phi
    @test v1.mass ≈ v2.mass atol = 1e-6

    for func in (px, py, pz, energy, pt, eta, phi)
        @test func(v1) ≈ func(FourVector(v1))
    end
    @test mass(v1) ≈ mass(FourVector(v1)) atol = 1e-6

    cart = FourVector(-2.3, 4.5, 0.23; E = 10.0)
    cyl = FourVectorCyl(cart)
    @test FourVector(cyl) ≈ cart
end

@testset "fromPtEtaPhiE" begin
    v1 = FourVectorCyl(1761.65, -2.30322, -2.5127, 0.105652)
    v2 = fromPtEtaPhiE(v1.pt, v1.eta, v1.phi, energy(v1))
    @test v1.mass ≈ v2.mass atol = 1e-6
end

@testset "Separation on Cartesian FourVector" begin
    if !isdefined(Main, :deltar)
        @info "Skipping separation tests until LorentzVectorBase exports deltar"
    else
        vcart1 = FourVector(-2.3, 4.5, 0.23; E = 10.0)
        vcart2 = FourVector(2.7, -4.1, -0.21; E = 10.0)
        @test deltaeta(vcart1, vcart2) ≈ 0.08825941862546584 atol = 1e-9
        @test deltaphi(vcart1, vcart2) ≈ 3.0317366429628736 atol = 1e-9
        @test deltar(vcart1, vcart2) ≈ sqrt(deltaeta(vcart1, vcart2)^2 + deltaphi(vcart1, vcart2)^2)
    end
end

@testset "FourVectorCyl broadcasting" begin
    pts = [1761.65, 115.906, 43.712420, 36.994347]
    etas = [-2.30322, -2.28564, 1.4733887, 0.38684082]
    phis = [-2.5127, -2.50781, 1.6855469, -1.3935547]
    mass_val = 0.105652
    vs = FourVectorCyl.(pts, etas, phis, mass_val)
    @test all(v.mass == mass_val for v in vs)
    @test fast_mass.(Ref(vs[1]), vs[2:end]) == [fast_mass(vs[1], v) for v in vs[2:end]]
end
