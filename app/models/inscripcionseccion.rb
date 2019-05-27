class Inscripcionseccion < ApplicationRecord
	# SET GLOBALES:
	FINAL = TipoCalificacion::FINAL
	DIFERIDO = TipoCalificacion::DIFERIDO
	REPARACION = TipoCalificacion::REPARACION
	PI = TipoCalificacion::PI

	# ASOCIACIONES: 
	belongs_to :seccion

	has_one :asignatura, through: :seccion
	has_one :escuela, through: :asignatura
		
	belongs_to :estudiante, primary_key: :usuario_id
	belongs_to :tipo_calificacion
	# belongs_to :tipo_estado_inscripcion
	belongs_to :tipoasignatura, optional: true
	
	# VARIABLES:
	enum estado: ['sin_calificar', :aprobado, :aplazado, :retirado]

	# TRIGGERS:
	after_initialize :set_default, :if => :new_record?
	before_validation :set_default

	# VALIDACIONES:
	validates_uniqueness_of :estudiante_id, scope: [:seccion_id], message: 'El estudiante ya está inscrito en la sección', field_name: false

	# SCOPES:
	# scope :confirmados, -> {where "confirmar_inscripcion = ?", 1}
	# scope :del_periodo_actual, -> {joins(:seccion).where "periodo_id = ?", ParametroGeneral.periodo_actual_id}
	# SON EQUIVALENTES LAS 2 SIGUIENTES SCOPE PERO FUNCIONAN DIFERENTES EN CONDICIONES PARTICULARES: 
	# scope :del_periodo, lambda { |periodo_id| includes(:seccion).where "secciones.periodo_id = ?", periodo_id}
	scope :del_periodo, lambda { |periodo_id| joins(:seccion).where "secciones.periodo_id = ?", periodo_id}

	scope :de_la_escuela, lambda {|escuela_id| includes(:escuela).where("escuelas.id = ?", escuela_id).references(:escuelas)}

	# scope :en_reparacion, -> {joins(:seccion).where "secciones.tipo_seccion_id = ?", TipoSeccion::REPARACION}
	scope :en_reparacion, -> {where tipo_calificacion_id.eql? REPARACION}
	# scope :no_retirados, -> {where "tipo_estado_inscripcion_id != ?", RETIRADA}
	scope :no_retirados, -> {where "estado != 3"}

	scope :estudiantes_inscritos_del_periodo, lambda { |periodo_id| joins(:seccion).where("secciones.periodo_id": periodo_id).group(:estudiante_id).count } 

	scope :estudiantes_inscritos, -> { group(:estudiante_id).count } 

	scope :estudiantes_inscritos_con_creditos, -> { joins(:asignatura).group(:estudiante_id).sum('asignaturas.creditos')} 

	# Esta función retorna la misma cuenta agrupadas por creditos de asignaturas
	scope :estudiantes_inscritos_con_creditos2, -> { joins(:asignatura).group('inscripcionsecciones.estudiante_id', 'asignaturas.creditos').count} 

	scope :secciones_creadas, -> { group(:seccion_id).count }

# Inscripcionseccion.joins(:seccion).joins(:estudiante).where("estudiantes.escuela_id": 'IDIO', "secciones.periodo_id": '2018-02A').group(:estudiante_id).count.count


	# Probar pero no hace falta ya que podemos hacer Inscripcionseccion.retirado / aprobado / aplazado / sin_calificacion
	# scope :retirados, -> {where "estado = 3"}
	# scope :aprobados, -> {where "estado = 1", :aprobado}
	# scope :aplazados, -> {where "estado = 2", :aplazado}
	# scope :sin_calificar, -> {where "tipo_calificacion_id = ?", 'SC'}

	scope :perdidos, -> {where "tipo_calificacion_id = ?", PI}

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

	def nota_final_para_csv
		# Notas 00 a 20 / AP = Aplasado, A = Aprobado, PI = , SN = Sin nota, NP
		if pi?
			return'00'
		elsif retirado?
			return 'RT'
		elsif !calificacion_completa?
			return 'SN'
		elsif seccion.asignatura.calificacion.eql? 0
			if aprobada?
				return 'A'
			else
				return 'AP'
			end
		elsif reprobado?
			return 'AP'
		else
			return colocar_nota.to_s
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
		if self.calificacion_final.nil?
			return 'SN'
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
		elsif particular			
			calificacion = (particular.eql? 'posterior') ? calificacion_posterior : calificacion_final
			valor = num_a_letras calificacion
		else
			calificacion = (diferido? || reparacion?) ? calificacion_posterior : calificacion_final
			valor = num_a_letras calificacion
		end
		return valor
	end

	def num_a_letras num

		case num
		when 1
			valor = "CERO UNO"
		when 2
			valor = "CERO DOS"
		when 3
			valor = "CERO TRES"
		when 4
			valor = "CERO CUATRO"
		when 5
			valor = "CERO CINCO"
		when 6
			valor = "CERO SEIS"
		when 7
			valor = "CERO SIETE"
		when 8
			valor = "CERO OCHO"
		when 9
			valor = "CERO NUEVE"
		when 10
			valor = "DIEZ"
		when 11
			valor = "ONCE"
		when 12
			valor = "DOCE"
		when 13
			valor = "TRECE"
		when 14
			valor = "CATORCE"
		when 15
			valor = "QUINCE"
		when 16
			valor = "DIEZ Y SEIS"
		when 17
			valor = "DIEZ Y SIETE"
		when 18
			valor = "DIEZ Y OCHO"
		when 19
			valor = "DIEZ Y NUEVE"
		when 20
			valor = "VEINTE"
		else
			valor = "SIN CALIFICACIÓN"
		end
		return valor
	end

	def nombre_estudiante_con_retiro
		aux = estudiante.usuario.apellido_nombre
		aux += " (retirado)" if retirado? 
		return aux
	end

	# def retirada?
	# 	# return (cal_tipo_estado_inscripcion_id.eql? RETIRADA) ? true : false
	# 	tipo_estado_inscripcion_id.eql? RETIRADA
	# end

	protected

	def set_default
		self.tipo_calificacion_id ||= FINAL
	end

end
