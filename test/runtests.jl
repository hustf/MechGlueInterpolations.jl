import MechGlueInterpolations
using Test
using MechGlueInterpolations: m
using MechGlueInterpolations: matrix_to_function
@testset "MechGlueInterpolations.jl" begin

    compm = [(complex(x-1, y-1.5)m) for x in 0.0:1:3, y in 0.0:1.5:3]
    xmin = 0.0m
    xmax = 3.0m
    ymin = 0.0m
    ymax = 3.0m
    nx= 3
    ny = 4
    matrix_to_function(compm, xmin, xmax, ymin, ymax, nx, ny)

end
