class Plan < ApplicationRecord

	# ASOCIACIONES:
	has_many :historialplanes

	accepts_nested_attributes_for :historialplanes

	has_many :estudiantes, through: :historialplanes, source: :estudiante

	# VALIDACIONES:
    validates :id, presence: true, uniqueness: true

	# FUNCIONES:
	def descripcion_completa
		"#{id} - #{descripcion}"
	end

end
