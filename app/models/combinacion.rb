class HistorialPlan < ApplicationRecord

	belongs_to :estudiante, primary_key: :usuario_ci

	belongs_to :periodo

	belongs_to :idioma1,
	class_name: 'Departamento',
	foreign_key: :idioma1_id
	accepts_nested_attributes_for :idioma1

	belongs_to :idioma2,
	class_name: 'Departamento',
	foreign_key: :idioma2_id
	accepts_nested_attributes_for :idioma2

	# validates_uniqueness_of :estudiante_id, scope: [:plan_id, :periodo_id]
end
