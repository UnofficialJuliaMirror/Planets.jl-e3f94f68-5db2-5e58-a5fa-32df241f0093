#=
Author: Daniel Carrera (dcarrera@gmail.com)

Compute stellar isochrones (luminosity, temperature, and logg) for AFGKM
stars up to 0.89 Gyr using the stellar models of Marigo et al. (2017).
=#
using DataFrames
using Statistics
using CSV

iso_names = [:Z, :t, :Mini, :Mass, :logL, :logTe, :logg]
iso_table = "$(@__DIR__)/../data/PARSEC_Isochrones_Z010.dat"
iso_table = CSV.read(iso_table, datarow=9, header=iso_names)

function isochrone(mass)
	#
	# The masses are not all the same at each time snapshot.
	#
	local df = DataFrame()
	df[:t] = unique(iso_table[:t])
	df[:logL] = 0.0
	df[:Te] = 0.0
	df[:logg] = 0.0
	
	local N = size(df,1)
	
	for j in 1:N
		t = df[j,:t]
		slice = iso_table[ iso_table[:t] .== t , :]
		
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
		df[j,:Te] = 10^lT
		
		lg0 = slice[i0,:logg]
		lg1 = slice[i1,:logg]
		lg = lg0 * (m1 - mass)/(m1 - m0) + lg1 * (m0 - mass)/(m0 - m1)
		df[j,:logg] = lg
	end
	
	return df
end
