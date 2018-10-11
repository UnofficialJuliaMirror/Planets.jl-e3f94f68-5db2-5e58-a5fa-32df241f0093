# Planets.jl
Functions related to planet formation or planet structure models.

## `core_radius`

Right now this package contains only one function, but I intend to add
more in the future. The function `core_radius` computes the radius of
a planetary core made of either pure (silicate) rock, a rock-iron mix,
or a rock-water mix. Cores with all three components are not supported. The function interpolates across the planet structure grid model of
Zeng et al. (2016), which is publicly available from [Li Zeng's website](https://www.cfa.harvard.edu/~lzeng/planetmodels.html#mrtables).

Examples:

	#
	# Radius of a 3.0 M_earth core with 10% water + 90% rock:
	#
	radius = core_radius(3.0, h2o=0.1) # In Earth radii.

	#
	# Radius of a 3.0 M_earth core with 10% iron + 90% rock:
	#
	radius = core_radius(3.0, fe=0.1) # In Earth radii.

Citation:
	
	Zeng et al (2016)
	http://adsabs.harvard.edu/abs/2016ApJ...819..127Z
