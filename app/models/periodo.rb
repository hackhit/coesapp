class Periodo < ApplicationRecord
	has_many :secciones
	accepts_nested_attributes_for :secciones

	has_many :estudiantes_secciones, through: :secciones, source: :estudiantes


	def anno
		"#{id.split('-').first}"
	end

	def periodo_anterior
		todos = Periodo.all #.order(:inicia :asc)
		indice = todos.index self
		indice -= 1
		indice = 0 if indice < 0
		
		return todos[indice]		
	end


end
