using FourVectors
using Test

p = FourVector(1.0, 2.0, 3.0; E = 4.0)

@test p.px == p[1]
@test p.py == p[2]
@test p.pz == p[3]
@test p.E == p[4]
#
@test p[1:3] == [p.px, p.py, p.pz]
