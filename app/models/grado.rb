class Grado < ApplicationRecord
	# ASOCIACIONES:
	belongs_to :escuela
	belongs_to :estudiante

	# has_many :inscripcionsecciones, foreign_key: [:escuela_id, :estudiante_id]

	scope :no_retirados, -> {where "estado != 3"}
	scope :cursadas, -> {where "estado != 3"}
	scope :aprobadas, -> {where "estado = 1"}
	scope :sin_equivalencias, -> {joins(:seccion).where "secciones.tipo_seccion_id != 'EI' and secciones.tipo_seccion_id != 'EE'"} 
	scope :por_equivalencia, -> {joins(:seccion).where "secciones.tipo_seccion_id = 'EI' or secciones.tipo_seccion_id = 'EE'"}
	scope :por_equivalencia_interna, -> {joins(:seccion).where "secciones.tipo_seccion_id = 'EI'"}
	scope :por_equivalencia_externa, -> {joins(:seccion).where "secciones.tipo_seccion_id = 'EE'"}
	scope :total_creditos_inscritos, -> {joins(:asignatura).sum('asignaturas.creditos')}

	enum estado: [:pregrado, :tesista, :posible_graduando, :graduando, :graduado]

	def inscripciones
		Inscripcionseccion.joins(:escuela).where("estudiante_id = ? and escuelas.id = ?", estudiante_id, escuela_id)
	end

	def id
		"#{escuela_id}-#{estudiante_id}"
	end

	def ultimo_plan
		hp = estudiante.historialplanes.por_escuela(escuela_id).order('periodo_id DESC').first
		hp ? hp.plan : nil
	end

	def descripcion_ultimo_plan
		plan = ultimo_plan
		if plan
			plan.descripcion_filtro
		else
			'Sin Plan Asignado'
		end
	end

	# private

	# def actualizar_estado_inscripciones
	# 	if asignatura.tipoasignatura_id.eql? Tipoasignatura::PROYECTO
	# 		if self.sin_calificar?
	# 			grado.update(estado :tesista)
	# 		elsif self.retirado? or self.aplazado
	# 			grado.update(estado :pregrado)
	# 		elsif self.aprobado?
	# 			grado.update(estado 'posible_graduando')
	# 		end
	# 	end
	# end	


end
