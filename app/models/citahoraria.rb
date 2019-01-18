class Citahoraria < ApplicationRecord
	# ASOCIACIONES:
	has_many :estudiantes

	# FUNCIONES:
	def descripcion 
		"#{estudiante_id} - #{fecha}" 
	end 
end

