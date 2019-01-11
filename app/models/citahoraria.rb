class Citahoraria < ApplicationRecord
	# ASOCIACIONES:
	belongs_to :estudiante

	# FUNCIONES:
	def descripcion 
		"#{estudiante_id} - #{fecha}" 
	end 
end

