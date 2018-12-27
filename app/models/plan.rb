class Plan < ApplicationRecord

	# ASOCIACIONES:
	has_many :historiales_planes,
	class_name: 'HistorialPlan'

	accepts_nested_attributes_for :historiales_planes

	has_many :estudiantes, through: :historiales_planes, source: :estudiante

	# VALIDACIONES:
    validates :id, presence: true, uniqueness: true

	# FUNCIONES:
	def descripcion_completa
		"#{id} - #{descripcion}"
	end

end
