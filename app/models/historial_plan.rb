class HistorialPlan < ApplicationRecord

	belongs_to :estudiante, primary_key: :usuario_id

	belongs_to :periodo

	belongs_to :plan

	# validates_uniqueness_of :estudiante_id, scope: [:plan_id, :periodo_id]
end
