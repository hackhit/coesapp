class Periodo < ApplicationRecord
	# ENUMERADAS CONSTANTES
	enum tipo: [:semestral, :anual, :unico]

	# ASOCIACIONES:
	has_many :secciones
	accepts_nested_attributes_for :secciones
	has_many :inscripcionsecciones, through: :secciones, source: :estudiantes

	has_many :escuelaperiodos
	accepts_nested_attributes_for :escuelaperiodos
	has_many :escuelas, through: :escuelaperiodos
	

	# VALIDACIONES:
    validates :id, presence: true, uniqueness: true
    validates :inicia, presence: true, uniqueness: true

	# FUNCIONES:
	def tiene_secciones?
		self.secciones.count > 0 		
	end

	def anno
		"#{id.split('-').first}"
	end

	def periodo_anterior
		todos = Periodo.all.order(inicia: :asc)
		indice = todos.index self
		indice -= 1
		indice = 0 if indice < 0
		
		return todos[indice]		
	end


end
