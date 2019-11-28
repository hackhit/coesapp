class Grado < ApplicationRecord
	#CONSTANTES:

	self.primary_keys = :estudiante_id, :escuela_id

	TIPO_INGRESOS = ['OPSU', 'OPSU/COLA', 'SIMADI', 'ACTA CONVENIO (DOCENTE)', 'ACTA CONVENIO (ADMIN)', 'ACTA CONVENIO (OBRERO)', 'DISCAPACIDAD', 'DIPLOMATICO', 'COMPONENTE DOCENTE', 'EQUIVALENCIA', 'ART. 25 (CULTURA)', 'ART. 25 (DEPORTE)', 'CAMBIO: 158', 'ART. 6', 'EGRESADO', 'SAMUEL ROBINSON', 'DELTA AMACURO', 'AMAZONAS', 'PRODES', 'CREDENCIALES']

	# ASOCIACIONES:
	belongs_to :escuela
	belongs_to :estudiante
	belongs_to :plan, optional: true

	has_many :historialplanes, foreign_key: [:estudiante_id, :escuela_id]
	
	has_many :inscripciones, class_name: 'Inscripcionseccion', foreign_key: [:estudiante_id, :escuela_id] 

	has_many :secciones, through: :inscripciones, source: :seccion

	# VALIDACIONES

	validates :tipo_ingreso, presence: true 
	validates :estado_inscripcion, presence: true 
	# validates :inscrito_ucv, presence: true 
	# has_many :inscripcionsecciones, foreign_key: [:escuela_id, :estudiante_id]

	scope :no_retirados, -> {where "estado != 3"}
	scope :cursadas, -> {where "estado != 3"}
	scope :aprobadas, -> {where "estado = 1"}
	scope :sin_equivalencias, -> {joins(:seccion).where "secciones.tipo_seccion_id != 'EI' and secciones.tipo_seccion_id != 'EE'"} 
	scope :por_equivalencia, -> {joins(:seccion).where "secciones.tipo_seccion_id = 'EI' or secciones.tipo_seccion_id = 'EE'"}
	scope :por_equivalencia_interna, -> {joins(:seccion).where "secciones.tipo_seccion_id = 'EI'"}
	scope :por_equivalencia_externa, -> {joins(:seccion).where "secciones.tipo_seccion_id = 'EE'"}
	scope :total_creditos_inscritos, -> {joins(:asignatura).sum('asignaturas.creditos')}

	scope :culminado_en_periodo, lambda { |periodo_id| where "culminacion_periodo_id = ?", periodo_id}
	scope :iniciados_en_periodo, lambda { |periodo_id| where "iniciado_periodo_id = ?", periodo_id}

	scope :de_las_escuelas, lambda {|escuelas_ids| where("escuela_id IN (?)", escuelas_ids)}
	scope :con_inscripciones, lambda { joins(:inscripcionsecciones) }

	scope :sin_plan, -> {where(plan_id: nil)}

	enum estado: [:pregrado, :tesista, :posible_graduando, :graduando, :graduado]

	enum estado_inscripcion: [:preinscrito, :confirmado, :reincorporado]

	enum tipo_ingreso: TIPO_INGRESOS

	# def inscripciones
	# 	Inscripcionseccion.joins(:escuela).where("estudiante_id = ? and escuelas.id = ?", estudiante_id, escuela_id)
	# end

	# Así debe ser inscripciones
	# def inscripciones
	# 	Inscripcionseccion.where("estudiante_id = ? and escuelas_id = ?", estudiante_id, escuela_id)
	# end


	def printHorario periodo_id
	data = Bloquehorario::DIAS
	data.unshift("")
	data.map!{|a| "<b>"+a[0..2]+"</b>"}
	data = [data]

	secciones_ids = secciones.where(periodo_id: periodo_id).ids 
	# bloques = Bloquehorario.where(horario_id: secciones_ids).group(entrada).having('HOUR(entrada)')# intento con Group

	# bloques = Bloquehorario.where(horario_id: secciones_ids).select("HOUR(entrada) AS hora", "bloquehorarios.id AS id").group('hora')# intento con Group
	bloques = Bloquehorario.where(horario_id: secciones_ids).collect{|bh| {horario: bh.dia_con_entrada, id: bh.id}}.uniq{|e| e[:horario] }
	p bloques	

	for i in 7..14 do
		for j in 0..3 do
			# aux = ["#{i.to_s}:#{sprintf("%02i", (j*15))}"]

			# Bloquehorario::DIAS.each do |dia|
			# 	aciertos = bloques.map{|b| b[:id] if b[:horario] == "#{dia} #{Bloquehorario.hora_descripcion "07:00".to_time}"}.compact
				
			# 	aciertos.each do |acierto|

			# 	end
			# 	aux << ""

			# end
			data << ["#{i.to_s}:#{sprintf("%02i", (j*15))}","","","","",""] # En blanco
		end
	end
	return data #bloques
	end




	def plan_descripcion_corta
		plan ? plan.descripcion_completa : '--'
	end

	def plan_descripcion
		plan ? plan.descripcion_completa : 'Sin plan asociado'
	end

	def total_creditos_cursados periodos_ids = nil
		if periodos_ids
			inscripciones.total_creditos_cursados_en_periodos periodos_ids
		else
			inscripciones.total_creditos_cursados
		end
	end

	def total_creditos_aprobados periodos_ids = nil
		if periodos_ids
 			inscripciones.total_creditos_aprobados_en_periodos periodos_ids
 		else
 			inscripciones.total_creditos_aprobados
 		end
	end

	def eficiencia periodos_ids = nil 
        cursados = self.total_creditos_cursados periodos_ids
        aprobados = self.total_creditos_aprobados periodos_ids
		(cursados and cursados > 0) ? (aprobados.to_f/cursados.to_f).round(4) : 0.0
	end

	def promedio_simple periodos_ids = nil
		if periodos_ids
			aux = inscripciones.de_los_periodos(periodos_ids).cursadas
		else
			aux = inscripciones.cursadas
		end

        (aux and aux.count > 0 and !aux.average('calificacion_final').nil?) ? aux.average('calificacion_final').round(4) : 0.0

	end

	def promedio_ponderado periodos_ids = nil
		if periodos_ids
			aux = inscripciones.de_los_periodos(periodos_ids).ponderado
		else
			aux = inscripciones.ponderado
		end
		cursados = self.total_creditos_cursados periodos_ids

		cursados > 0 ? (aux.to_f/cursados.to_f).round(4) : 0.0
	end


	def inscrito_en_periodo? periodo_id
		(inscripciones.del_periodo(periodo_id)).count > 0
	end


	def id_flat
		id.join("-") #{}"#{escuela_id}-#{estudiante_id}"
	end

	def ultimo_plan
		aux = plan
		if plan.nil?
			hp = estudiante.historialplanes.por_escuela(escuela_id).order('periodo_id DESC').first	
			aux = hp ? hp.plan : nil
		else
			aux = plan
		end
		return aux 
		# hp = estudiante.historialplanes.por_escuela(escuela_id).order('periodo_id DESC').first
		# hp ? hp.plan : nil
	end

	def descripcion_ultimo_plan
		plan = ultimo_plan
		if plan
			plan.descripcion_completa_con_escuela
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
