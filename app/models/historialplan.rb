class Historialplan < ApplicationRecord
	# self.table_name = 'historiales_planes'

	belongs_to :estudiante, primary_key: :usuario_id
	belongs_to :periodo
	belongs_to :plan

	# OJO: Esta debe ser la validación: Que un estudiante no tenga más de un plan para un mismo periodo
	validates_uniqueness_of :estudiante_id, scope: [:periodo_id], message: 'El estudiante ya tiene un plan para el periodo', field_name: false

	def descripcion
		"#{plan.descripcion_completa} - #{periodo_id}"
	end

	def self.carga_inicial
		begin
			Estudiante.where("plan IS NOT NULL").each do |e|
				if e.plan and e.plan.include? '290'
					plan_id = Plan.where("id LIKE '%290%'").limit(1).first.id
				elsif e.plan and e.plan.include? '280'
					plan_id = Plan.where("id LIKE '%280%'").limit(1).first.id
				else
					plan_id = Plan.where("id LIKE '%270%'").limit(1).first.id
				end

				print "ID: #{e.id}--- Plan: #{plan_id} .#{e.plan}."
				HistorialPlan.create(estudiante_id: e.id, plan_id: plan_id)
			end			
		rescue Exception => e
			return e
		end
	end

end
