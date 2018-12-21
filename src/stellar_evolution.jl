#=
Author: Daniel Carrera (dcarrera@gmail.com)

=#
using DataFrames
using Statistics
using CSV

parsec_names = [:Z, :t, :Mini, :Mass, :logL, :logTe, :logg]
parsec_table = "$(@__DIR__)/../data/PARSEC_Isochrones_Z010.dat"
parsec_table = CSV.read(parsec_table, datarow=9, header=parsec_names)

"""
Compute the stellar evolution tracks (luminosity, temperature, logg) for
AFGKM with a metallicity of Z = 1.0%, up to an age of 0.89 Gyr, using the
stellar models of Marigo et al. (2017). This function returns a dataframe
with the following columns

	:t		Age of the star (years)
	:Teff   Star's effective temperature (K)
	:logL	Log base 10 of the stellar luminosity (L_sun)
	:logg   Log gravity.

Example:

	M_star = 0.5 # Solar masses.
	
	df = stellar_evolution(M_star)
	
	df[1,:t]
	df[1,:Teff]
	df[1,:logL]
	df[1,:logg]
	
Citation:
	
	Marigo et al. (2017)
	http://stev.oapd.inaf.it/cgi-bin/cmd
	http://adsabs.harvard.edu/abs/2017ApJ...835...77M
"""

function stellar_evolution(mass)
	#
	# The masses are not all the same at each time snapshot.
	#
	local df = DataFrame()
	df[:t] = unique(parsec_table[:t])
	df[:Teff] = 0.0
	df[:logL] = 0.0
	df[:logg] = 0.0
	
	local N = size(df,1)
	
	for j in 1:N
		t = df[j,:t]
		slice = parsec_table[ parsec_table[:t] .== t , :]
		
		if mass <= minimum(slice[:Mini])
			@error("$mass Ms <= $(minimum(slice[:Mini])) Ms at j = $j, t = $t")
		end
		if mass >= maximum(slice[:Mini])
			@error("$mass Ms >= $(maximum(slice[:Mini])) Ms at j = $j, t = $t")
		end
		#
		# Linear interpolation in logL, logTe, and logg.
		#
		i0 = sum(slice[:Mini] .< mass)
		i1 = i0 + 1
		
		m0 = slice[i0,:Mini]
		m1 = slice[i1,:Mini]
		
		lL0 = slice[i0,:logL]
		lL1 = slice[i1,:logL]
		lL  = lL0 * (m1 - mass)/(m1 - m0) + lL1 * (m0 - mass)/(m0 - m1)
		df[j,:logL] = lL
		
		lT0 = slice[i0,:logTe]
		lT1 = slice[i1,:logTe]
		lT = lT0 * (m1 - mass)/(m1 - m0) + lT1 * (m0 - mass)/(m0 - m1)
		df[j,:Teff] = 10^lT
		
		lg0 = slice[i0,:logg]
		lg1 = slice[i1,:logg]
		lg = lg0 * (m1 - mass)/(m1 - m0) + lg1 * (m0 - mass)/(m0 - m1)
		df[j,:logg] = lg
	end
	
	return df
end
