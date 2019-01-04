class Cartelera < ApplicationRecord

	scope :activas, -> {where "activa = ?", 1}


	def activada_valor
		activa ? 'Activada' : 'Desactivada'
		
	end
end
