class Inscripcionseccion < ApplicationRecord
	# SET GLOBALES:
	# self.table_name = 'inscripciones_en_secciones'
	# ASOCIACIONES: 
	belongs_to :seccion
	belongs_to :estudiante, primary_key: :usuario_id
	belongs_to :tipo_estado_calificacion
	belongs_to :tipo_estado_inscripcion

	# TRIGGERS:
	after_initialize :set_default, :if => :new_record?

	# VALIDACIONES:
	validates_uniqueness_of :estudiante_id, scope: [:seccion_id], message: 'El estudiante ya está inscrito en la sección', field_name: false

	# SCOPES:
	# scope :confirmados, -> {where "confirmar_inscripcion = ?", 1}
	scope :del_periodo_actual, -> {joins(:seccion).where "periodo_id = ?", ParametroGeneral.periodo_actual_id}
	scope :del_periodo, lambda { |periodo_id| joins(:seccion).where "periodo_id = ?", periodo_id}

	scope :en_reparacion, -> {joins(:seccion).where "numero LIKE ?", 'R'}
	scope :no_retirados, -> {where "tipo_estado_inscripcion_id != ?", 'RET'}
	scope :retirados, -> {where "tipo_estado_inscripcion_id = ?", 'RET'}
	scope :aprobados, -> {where "tipo_estado_calificacion_id = ?", 'AP'}
	scope :reprobados, -> {where "tipo_estado_calificacion_id = ?", 'RE'}
	scope :perdidos, -> {where "tipo_estado_calificacion_id = ?", 'PI'}
	scope :sin_calificar, -> {where "tipo_estado_calificacion_id = ?", 'SC'}


	def nota_final_para_csv
		# Notas 00 a 20 / AP = Aplasado, A = Aprobado, PI = , SN = Sin nota, NP
		if pi?
			return'00'
		elsif retirada?
			return 'RT'
		elsif !calificacion_completa?
			return 'SN'
		elsif seccion.asignatura_id.eql? 'SERCOM'
			if aprobada?
				return 'A'
			else
				return 'AP'
			end
		elsif reprobada?
			return 'AP'
		else
			return colocar_nota.to_s
		end

	end

	def calificacion_para_kardex
		return calificacion_completa? ? calificacion_final : 'SN'
	end

	def reprobada?
		return tipo_estado_calificacion_id.eql? 'RE'
	end

	def aprobada?
		return tipo_estado_calificacion_id.eql? 'AP'
	end

	def calificacion_completa?
		if primera_calificacion.nil? or segunda_calificacion.nil? or tercera_calificacion.nil? or calificacion_final.nil?
			return false
		else
			return true
		end
	end

	def descripcion
		aux = seccion.asignatura.descripcion
		aux += " <b>(Retirada)</b>" if retirada?
		return aux
	end

	def pi?
		tipo_estado_calificacion_id.eql? 'PI'
	end

	def colocar_nota
		if calificacion_final.nil?
			return 'SN'
		else
			return sprintf("%02i",calificacion_final)
		end
	end

	def tipo_calificacion
		tipo = ''
		if retirada?
			tipo = 'RT'
		elsif pi?
			tipo = 'PI'
		elsif calificacion_final.nil?
			tipo = 'PD'
		else

			if cal_seccion.numero.include? 'R'
				tipo = calificacion_final.to_i > 9 ? 'RA' : 'RR'
			else
				tipo = calificacion_final.to_i > 9 ? 'NF' : 'AP'
			end
		end
		return tipo
	end

	def calificacion_en_letras

		valor = ''
		if retirada?
			valor = 'RETIRADA'
		elsif pi?
			valor = 'PERDIDA POR INASISTENCIA'
		elsif calificacion_final.nil?
			valor = 'POR DEFINIR'
		else
			# CAMBIA POR ENUM
			case calificacion_final
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
				valor = "SIN VALOR"
			end						
		end
		return valor
	end

	def nombre_estudiante_con_retiro
		aux = estudiante.usuario.apellido_nombre
		aux += " (retirado)" if retirada? 
		return aux
	end

	def retirada?
		# return (cal_tipo_estado_inscripcion_id.eql? 'RET') ? true : false
		tipo_estado_inscripcion_id.eql? 'RET'
	end

	protected
	def set_default
		self.tipo_estado_inscripcion_id ||= 'NUEVO'
		self.tipo_estado_calificacion_id ||= 'SC'
	end

end
