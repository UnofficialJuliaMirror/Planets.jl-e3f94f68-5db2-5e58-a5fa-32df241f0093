#=
Author: Daniel Carrera (dcarrera@gmail.com)

Compute the habitable zone limits from Kopparapu et al. (2013).
=#

"""
Computes all the limits for the habitable zone from Kopparapu et al. (2013).
This function uses the updated coefficients from the erratum.

Input:

    Teff       Star's effective temperature (K)
	L_star     Star's luminosity (L_sun)

Example:
	
	Teff   = 3700  # Temperature of a 0.5 M_sun star.
	L_star = 0.04  # Luminosity of a 0.5 M_sun star.
	
	limits = habitable_zone(Teff, L_star)
	
	@info("Recent Venus       = \$(limits[1]) AU")
	@info("Runaway Greenhouse = \$(limits[2]) AU")
	@info("Moist Greenhouse   = \$(limits[3]) AU")
	@info("Maximum Greenhouse = \$(limits[4]) AU")
	@info("Early Mars         = \$(limits[5]) AU")

Citations:
	
	Kopparapu et al. (2013)
	http://adsabs.harvard.edu/abs/2013ApJ...765..131K
	
	Erratum
	http://adsabs.harvard.edu/abs/2013ApJ...770...82K
"""
function habitable_zone(Teff::Number, L_star::Number)
	@assert(Teff >= 2600)
	@assert(Teff <= 7200)
	
	Ts = Teff - 5780
	
	Seff_sun = [1.7763 1.0385 1.0146 0.3507 0.3207]

 	a =   [1.4335e-4    1.2456e-4    8.1884e-5    5.9578e-5    5.4471e-5 ]
	b =   [3.3954e-9    1.4612e-8    1.9394e-9    1.6707e-9    1.5275e-9 ]
	c = - [7.6364e-12   7.6345e-12   4.3618e-12   3.0058e-12   2.1709e-12]
	d = - [1.1950e-15   1.7511e-15   6.8260e-16   5.1925e-16   3.8282e-16]
	
	limits = zeros(5)
	for j in 1:5
		Seff = Seff_sun[j] + a[j]*Ts + b[j]*Ts^2 + c[j]*Ts^3 + d[j]*Ts^4
		
		limits[j] = sqrt(L_star / Seff) # AU
	end
	
	return limits
end
