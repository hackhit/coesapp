class CitaHoraria < ApplicationRecord
	# SET GLOBALES:
	self.primary_key = :estudiante_id
	self.table_name = 'citas_horarias'

	# ASOCIACIONES:
	belongs_to :estudiante

	# FUNCIONES:
	def descripcion 
		"#{fecha} - #{hora}" 
	end 
end

