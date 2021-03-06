class Inscripcionseccion < ApplicationRecord
	# SET GLOBALES:
	FINAL = TipoCalificacion::FINAL
	PARCIAL = TipoCalificacion::PARCIAL
	DIFERIDO = TipoCalificacion::DIFERIDO
	REPARACION = TipoCalificacion::REPARACION
	PI = TipoCalificacion::PI

	# ASOCIACIONES: 
	belongs_to :seccion
	belongs_to :estudiante, primary_key: :usuario_id

	has_one :asignatura, through: :seccion
	has_one :periodo, through: :seccion

	belongs_to :escuela

	belongs_to :grado, primary_key: ['estudiante_id', 'escuela_id'], foreign_key: ['estudiante_id', 'escuela_id']

	# has_one :escuela, through: :asignatura

	belongs_to :pci_escuela, foreign_key: 'pci_escuela_id', class_name: 'Escuela', optional: true

	# has_many :programaciones, through: :asignatura, source: :periodo

	has_one :usuario, through: :estudiante
	belongs_to :tipo_calificacion
	# belongs_to :tipo_estado_inscripcion
	belongs_to :tipoasignatura, optional: true
	
	# VARIABLES:
	enum estado: ['sin_calificar', :aprobado, :aplazado, :retirado, :trimestre1, :trimestre2]

	# TRIGGERS:
	after_initialize :set_default, :if => :new_record?
	before_validation :set_estados
	after_save :actualizar_estado_grado

	# VALIDACIONES:
	validates_uniqueness_of :estudiante_id, scope: [:seccion_id], message: 'El estudiante ya está inscrito en la sección', field_name: false

	# SCOPES:
	# scope :confirmados, -> {where "confirmar_inscripcion = ?", 1}
	# scope :del_periodo_actual, -> {joins(:seccion).where "periodo_id = ?", ParametroGeneral.periodo_actual_id}
	# SON EQUIVALENTES LAS 2 SIGUIENTES SCOPE PERO FUNCIONAN DIFERENTES EN CONDICIONES PARTICULARES: 
	# scope :del_periodo, lambda { |periodo_id| includes(:seccion).where "secciones.periodo_id = ?", periodo_id}
	scope :del_periodo, lambda { |periodo_id| joins(:seccion).where "secciones.periodo_id = ?", periodo_id}
	scope :de_los_periodos, lambda { |periodos_ids| joins(:seccion).where "secciones.periodo_id IN (?)", periodos_ids}


	# scope :en_reparacion, -> {joins(:seccion).where "secciones.tipo_seccion_id = ?", TipoSeccion::REPARACION}
	scope :en_reparacion, -> {where tipo_calificacion_id.eql? REPARACION}
	# scope :no_retirados, -> {where "tipo_estado_inscripcion_id != ?", RETIRADA}

	scope :de_la_escuela, lambda {|escuela_id| includes(:escuela).where("escuelas.id = ?", escuela_id).references(:escuelas)}

	# Así debe ser de_la_escuela
	# scope :de_la_escuela, lambda {|escuela_id| where("escuelas_id = ?", escuela_id)}
	# scope :de_las_escuelas, lambda {|escuelas_ids| where("escuelas.id IN (?)", escuelas_ids)}

	scope :de_las_escuelas, lambda {|escuelas_ids| includes(:escuela).where("escuelas.id IN (?)", escuelas_ids).references(:escuelas)}

	scope :grados, -> {joins(:asignatura).where("asignaturas.tipoasignatura_id = ?", Tipoasignatura::PROYECTO)}

	scope :posibles_graduandos, -> {joins(:grado).where("grados.estado = 2")}

	scope :no_absolutas, -> {joins(:asignatura).where("asignaturas.calificacion != 1")}
	scope :absolutas, -> {joins(:asignatura).where("asignaturas.calificacion = 1")}

	scope :no_retirados, -> {where "estado != 3"}
	scope :cursadas, -> {where "estado = 1 or estado = 2"}
	scope :en_curso, -> {where "estado != 1 and estado != 2 and estado != 3"} # Excluye retiradas también
	scope :aprobadas, -> {where "estado = 1"}
	
	scope :total_creditos_cursados_en_periodos, lambda{|periodos_ids| cursadas.joins(:seccion).where('secciones.periodo_id IN (?)', periodos_ids).joins(:asignatura).sum('asignaturas.creditos')}

	scope :total_creditos_aprobados_en_periodos, lambda{|periodos_ids| aprobadas.joins(:seccion).where('secciones.periodo_id IN (?)', periodos_ids).joins(:asignatura).sum('asignaturas.creditos')}

	scope :total_creditos, -> {joins(:asignatura).sum('asignaturas.creditos')}

	scope :total_creditos_cursados, -> {cursadas.total_creditos}
	scope :total_creditos_aprobados, -> {aprobadas.total_creditos}
	scope :ponderado, -> {joins(:asignatura).sum('asignaturas.creditos * calificacion_final')}
	scope :promedio, -> {average('calificacion_final')}
	scope :promedio_aprobadas, -> {aprobadas.promedio}
	scope :ponderado_aprobadas, -> {aprobadas.ponderado}

	scope :sin_equivalencias, -> {joins(:seccion).where "secciones.tipo_seccion_id != 'EI' and secciones.tipo_seccion_id != 'EE'"} 
	scope :por_equivalencia, -> {joins(:seccion).where "secciones.tipo_seccion_id = 'EI' or secciones.tipo_seccion_id = 'EE'"}
	scope :por_equivalencia_interna, -> {joins(:seccion).where "secciones.tipo_seccion_id = 'EI'"}
	scope :por_equivalencia_externa, -> {joins(:seccion).where "secciones.tipo_seccion_id = 'EE'"}

	scope :estudiantes_inscritos_del_periodo, lambda { |periodo_id| joins(:seccion).where("secciones.periodo_id": periodo_id).group(:estudiante_id).count } 

	scope :por_total_calificaciones?, -> {joins(:asignatura).group("asignaturas.calificacion").count}

	scope :estudiantes_inscritos, -> { group(:estudiante_id).count } 

	scope :estudiantes_inscritos_con_creditos, -> { joins(:asignatura).group(:estudiante_id).sum('asignaturas.creditos')} 

	# Esta función retorna la misma cuenta agrupadas por creditos de asignaturas
	scope :estudiantes_inscritos_con_creditos2, -> { joins(:asignatura).group('inscripcionsecciones.estudiante_id', 'asignaturas.creditos').count} 

	scope :secciones_creadas, -> { group(:seccion_id).count }

	scope :con_calificacion, -> {where('estado >= 1 and estado <= 3')}


# Inscripcionseccion.joins(:seccion).joins(:estudiante).where("estudiantes.escuela_id": 'IDIO', "secciones.periodo_id": '2018-02A').group(:estudiante_id).count.count


	# Probar pero no hace falta ya que podemos hacer Inscripcionseccion.retirado / aprobado / aplazado / sin_calificacion
	# scope :retirados, -> {where "estado = 3"}
	# scope :aprobados, -> {where "estado = 1", :aprobado}
	# scope :aplazados, -> {where "estado = 2", :aplazado}
	# scope :sin_calificar, -> {where "tipo_calificacion_id = ?", 'SC'}

	scope :perdidos, -> {where "tipo_calificacion_id = ?", PI}

	scope :como_pcis, -> {where pci: true}

	# scope :pcis_pendientes_por_asociar, -> {joins(:escuela).where("pci_escuela_id IS NULL and (escuela.id ON ( SELECT escuelas.id FROM escuelas INNER JOIN grados ON escuelas.id = grados.escuela_id WHERE grados.estudiante_id = ? ) )", self.estudiante_id)}

	# Funciones de Estilo
	def tr_class_style_qualify
		valor = ''
		valor = 'table-success' if self.aprobado?
		valor = 'table-danger' if (self.aplazado? || self.retirado? || self.pi?)
		valor += ' text-muted' if self.retirado?
		return valor
	end

	def descripcion_ultimo_plan
		plan = ultimo_plan
		if plan
			plan.descripcion_filtro
		else
			'Sin Plan Asignado'
		end
	end

	def ultimo_plan
		grado ? grado.ultimo_plan : nil
	end

	# Funciones Generales

	def grado_id
		"#{escuela_id}-#{estudiante_id}"
	end

	def grado
		# escuela_id = self.pci_escuela_id ? self.pci_escuela_id : self.escuela.id
		Grado.where(estudiante_id: self.estudiante_id, escuela_id: escuela_id).first
	end


	def descripcion_asignatura_pdf
		aux = seccion.asignatura.descripcion
		aux += " <b> (PCI) </b>" if self.como_pci?
		aux += " <b> (#{retirado_en_letras}) </b>" if self.retirado?
		return aux
	end

	def retirado_en_letras
		gen = estudiante.usuario.genero
		if retirado?
			return "Retirad#{gen}"
		else
			return ""
		end
	end

	def id_foranea
		foranea? ? "foranea_#{id}" : id
	end

	def foranea?
		!(estudiante.escuelas.include? asignatura.escuela)
	end

	def pci_pendiente_por_asociar? 
		pci_escuela_id.nil? and foranea?
	end

	def como_pci?
		!pci_escuela_id.nil?
	end

	def label_pci
		if como_pci?
			return "<span class='badge badge-success'>PCI para #{pci_escuela.descripcion}</span>" 
		else
			return ""
		end
	end

	def estado_a_letras
		case estado
		when 'retirado'
			return 'RT'
		when 'aprobado'
			return 'A'
		when 'aplazado'
			return 'AP'
		else
			return 'SC'
		end
	end

	def estado_inscripcion
		if self.sin_calificar?
			return 'Inscrito'
		else
			return self.estado.titleize
		end
	end

	def estado_segun_calificacion
		
		if seccion and seccion.asignatura and !seccion.asignatura.absoluta?
			nota = (reparacion? || diferido?) ? calificacion_posterior : calificacion_final
			if nota and nota >= 10 
				return :aprobado
			else
				return :aplazado
			end
		else
			return self.estado
		end

	end

	def pi?
		tipo_calificacion_id.eql? PI
	end

	def reparacion?
		self.tipo_calificacion_id.eql? REPARACION
	end

	def diferido?
		self.tipo_calificacion_id.eql? DIFERIDO
	end

	def no_presento?
		self.diferido?
	end

	def d_or_r? 

		tipo_calificacion_id.to_s.first

		
	end

	def nota_final_para_csv reparacion = false
		# Notas 00 a 20 / AP = Aplasado, A = Aprobado, PI = , SN = Sin nota, NP
		if self.pi?
			return'00'
		elsif self.retirado?
			return 'RT'
		elsif self.sin_calificar?
			return 'SN'
		elsif self.seccion.asignatura.absoluta?
			if self.aprobado?
				return 'A'
			else
				return 'AP'
			end
		else

			return self.colocar_nota_final.to_s
		end

	end


	def tipo_convocatoria explicita = nil

		if explicita.eql? 'F'
			return "F#{seccion.periodo.valor_para_tipo_convocatoria}"
		elsif explicita.eql? 'R'
			return "R#{seccion.periodo.valor_para_tipo_convocatoria}"
		else
			if self.reparacion?
				return "R#{seccion.periodo.valor_para_tipo_convocatoria}"
			else
				return "F#{seccion.periodo.valor_para_tipo_convocatoria}"
			end
		end
	end

	# def calificacion_para_kardex
	# 	return calificacion_completa? ? calificacion_final : 'SN'
	# end

	# def reprobada?
	# 	return aplazada?
	# end
	# def aplazada?
	# 	if seccion.asignatura.absoluta?
	# 		return (tipo_estado_calificacion_id.eql? 'AP' or no_presento?)
	# 	elsif no_presento? and calificacion_final < 10
	# 		return true
	# 	else 
	# 		return tipo_estado_calificacion_id.eql? 'AP'
	# 	end
	# end

	# def aprobada?

	# 	if seccion.asignatura.absoluta?
	# 		if no_presento?
	# 			return false
	# 		else
	# 			tipo_estado_calificacion_id.eql? 'A'
	# 		end	
	# 	elsif no_presento?
	# 		return calificacion_final > 10
	# 	else
	# 		tipo_estado_calificacion_id.eql? 'A'
	# 	end

	# end

	# def calificacion_completa?
	# 	if primera_calificacion.nil? or segunda_calificacion.nil? or tercera_calificacion.nil? or calificacion_final.nil?
	# 		return false
	# 	else
	# 		return true
	# 	end
	# end

	def descripcion periodo_id
		aux = seccion.asignatura.descripcion_pci periodo_id
		aux += " <b>(Retirada)</b>" if retirado?
		return aux
	end

	# def estado
	# 	if retirado?
	# 		return "Retirada"
	# 	elsif aprobada?
	# 		return 'Aprobada'
	# 	elsif aplazada?
	# 		return 'Aplazada'
	# 	else
	# 		return tipo_estado_calificacion.descripcion.titleize
	# 	end

	# end

	def valor_calificacion incluir_tipo = false, final_o_posterior = nil
		valor = ''
		if retirado?
			valor = '--'
		elsif seccion.asignatura.absoluta?
			if self.aprobado?
				valor = 'A'
			else
				valor = 'AP'
			end
		else
			if final_o_posterior.eql? 'F'
				valor = colocar_nota_final
			elsif final_o_posterior.eql? 'P'	
				valor = colocar_nota_posterior
			else
				valor = colocar_nota
			end
		end
		valor += " (#{self.tipo_calificacion_id})" if incluir_tipo and self.tipo_calificacion_id  and !self.retirado?
		return valor
	end

	def colocar_nota_final
		if retirado? 
			return '--'
		elsif self.calificacion_final.nil?
			return 'SN'
		elsif seccion.asignatura.absoluta?
			if self.aprobado?
				valor = 'A'
			else
				valor = 'AP'
			end			
		else
			return sprintf("%02i", self.calificacion_final)
		end		
	end

	def colocar_nota_posterior
		if self.calificacion_posterior.nil?
			return 'SN'
		else
			return sprintf("%02i", self.calificacion_posterior)
		end		
	end

	def tiene_calificacion_posterior?
		(self.reparacion? || self.diferido?) and self.calificacion_posterior
	end

	def colocar_nota
		if self.tiene_calificacion_posterior?
			return self.colocar_nota_posterior
		else
			return self.colocar_nota_final
		end
	end

	def tipo_calificacion_to_cod
		tipo = ''
		if retirado?
			tipo = 'RT'
		elsif pi?
			tipo = PI
		elsif calificacion_final.nil?
			tipo = 'PD'
		else

			if reparacion?
				tipo = calificacion_final.to_i > 9 ? 'RA' : 'RR'
			else
				tipo = calificacion_final.to_i > 9 ? 'NF' : 'AP'
			end
		end
		return tipo
	end

	def calificacion_en_letras particular = nil

		valor = ''
		if retirado?
			valor = 'RETIRADO'
		elsif pi?
			valor = 'PÉRDIDA POR INASISTENCIA'
		elsif  sin_calificar?
			valor = 'POR DEFINIR'
		elsif seccion.asignatura.absoluta?
			valor = self.estado.upcase
		else
			calificacion = (diferido? || reparacion? || particular.eql?('posterior')) ? calificacion_posterior : calificacion_final
			valor = num_a_letras calificacion
		end
		return valor
	end

	def num_a_letras num
		numeros = %W(CERO UNO DOS TRES CUATRO CINCO SEIS SIETE OCHO NUEVE DIEZ ONCE DOCE TRECE CATORCE QUINCE)

		return 'CALIFICACIÓN PENDIENTE' if num.nil? or !(num.is_a? Integer or num.is_a? Float)
		num = num.to_i
			
		if num < 10 
			return "#{numeros[0]} #{numeros[num]}"
		elsif num >= 10  and num < 16
			return numeros[num]
		elsif num >= 16 and num < 20
			aux = num % 10
			return "#{numeros[10]} Y #{numeros[aux]}"
		elsif num == 20
			return 'VEINTE'
		else
			return 'CALIFICACIÓN PENDIENTE'
		end
		

	end

	def nombre_estudiante_con_retiro
		aux = estudiante.usuario.apellido_nombre
		aux += " (retirado)" if retirado? 
		return aux
	end

	def nombre_estudiante_con_retiro_plus
		aux = "#{estudiante.usuario.apellido_nombre}"
		aux += " <div class='badge badge-info'>Retirada</div>" if retirado? 
		return aux
	end


	# def retirada?
	# 	# return (cal_tipo_estado_inscripcion_id.eql? RETIRADA) ? true : false
	# 	tipo_estado_inscripcion_id.eql? RETIRADA
	# end
 
	def inscrita_como_pci?
		self.escuela_id and self.escuela_id.eql? seccion.escuela.id ? false : true
	end

	protected

	def set_escuela_default
		self.escuela_id = estudiante.escuelas.first.id if (escuela_id.nil? and estudiante and estudiante.escuelas.count == 1)
	end

	def set_estados
		self.tipo_calificacion_id ||= FINAL
		if self.retirado?
			self.calificacion_final = nil
		elsif self.asignatura and self.asignatura.absoluta?
			self.primera_calificacion = nil
			self.segunda_calificacion = nil
			self.tercera_calificacion = nil
			self.calificacion_final = self.aprobado? ? 20 : 1
			self.calificacion_posterior = nil
			self.tipo_calificacion_id = TipoCalificacion::FINAL
		elsif self.pi?
			self.estado = :aplazado
			self.primera_calificacion = nil
			self.segunda_calificacion = nil
			self.tercera_calificacion = nil
			self.calificacion_final = 1
			self.calificacion_posterior = nil
		elsif self.calificacion_posterior

			if self.calificacion_posterior.to_i >= 10
				self.estado = :aprobado
			else
				self.estado = :aplazado
			end
		elsif self.calificacion_final
			if self.calificacion_final.to_i >= 10
				self.tipo_calificacion_id ||= FINAL
				self.calificacion_posterior = nil
				self.estado = :aprobado
			else
				self.estado = :aplazado
			end
		elsif self.asignatura and self.asignatura.numerica3?
			if self.segunda_calificacion
				self.estado = :trimestre2
			elsif self.primera_calificacion
				self.estado = :trimestre1
			end
		end

		if self.calificacion_final && self.calificacion_final.to_i >= 10
			self.tipo_calificacion_id = FINAL
			self.calificacion_posterior = nil
			self.estado = :aprobado
		end
		self.set_escuela_default
		
		self.pci = self.inscrita_como_pci?
	end

	def actualizar_estado_grado
		if asignatura.tipoasignatura_id.eql? Tipoasignatura::PROYECTO
			if self.sin_calificar?
				Grado.where(escuela_id: escuela.id, estudiante_id: estudiante_id).update_all(estado: 1, culminacion_periodo_id: nil)
			elsif self.retirado? or self.aplazado?
				Grado.where(escuela_id: escuela.id, estudiante_id: estudiante_id).update_all(estado: 0, culminacion_periodo_id: nil)
			elsif self.aprobado?
				Grado.where(escuela_id: escuela.id, estudiante_id: estudiante_id).update_all(estado: 2, culminacion_periodo_id: periodo.id)
			end
		end
		return true
	end

	def set_default
		self.tipo_calificacion_id ||= FINAL
	end


end
