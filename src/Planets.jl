module Planets

include("radius.jl")
export core_radius

include("accretion.jl")
export accretion_rate

include("stellar_evolution.jl")
export stellar_evolution

end # module
