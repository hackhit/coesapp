class Plan < ApplicationRecord

	has_many :historiales_planes,
	class_name: 'EstudiantePlan'#,foreign_key: :plan_id

	accepts_nested_attributes_for :historiales_planes

	has_many :estudiantes, through: :historiales_planes, source: :estudiante

	def descripcion_completa
		"#{id} - #{descripcion}"
	end

end
