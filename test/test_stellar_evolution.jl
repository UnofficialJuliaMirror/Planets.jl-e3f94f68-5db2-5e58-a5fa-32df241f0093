tol = 1e-10
#
# Sanity check and test grid points.
#
df = stellar_evolution(0.1914602816)
@test all(names(df) .== [:t, :logL, :Te, :logg])
@test minimum(df[:t]) == 1e5
@test maximum(df[:t]) == 8.91e8

@test abs(df[1,:t]    - 1e5        ) < tol
@test abs(df[1,:logL] + 0.209      ) < tol
@test abs(df[1,:Teff] - 10^(3.5162)) < tol
@test abs(df[1,:logg] - 2.946      ) < tol
#
# Test interpolation.
#
m1 = 0.7978261113
m2 = 0.8456522226
df = stellar_evolution((m1 + m2)/2)

@test abs(df[1,:logL] - (0.959+1.007)/2       ) < tol
@test abs(df[1,:Teff] - 10^((3.6480+3.6509)/2)) < tol
@test abs(df[1,:logg] - (2.925+2.914)/2       ) < tol

