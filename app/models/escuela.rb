class Escuela < ApplicationRecord

	# ASOCIACIONES
	has_many :escuelaestudiantes
	has_many :estudiantes, through: :escuelaestudiantes

	has_many :departamentos
	accepts_nested_attributes_for :departamentos
	
	has_many :asignaturas, through: :departamentos
	
	has_many :profesores, through: :departamentos

	has_many :secciones, through: :asignaturas


	has_many :estudiantes
	accepts_nested_attributes_for :estudiantes	

	has_many :inscripcionsecciones, through: :secciones

	has_many :escuelaperiodos
	accepts_nested_attributes_for :escuelaperiodos
	has_many :periodos, through: :escuelaperiodos

	has_many :planes
	accepts_nested_attributes_for :planes


	has_many :administradores
	accepts_nested_attributes_for :administradores

	# TRIGGERS
	before_save :set_to_upcase

	#SCOPES
	def inscripciones_en_periodo? periodo_id
		self.inscripcionsecciones.where("secciones.periodo_id = ?", periodo_id).count > 0
	end

	def secciones_en_periodo? periodo_id
		self.secciones.where("periodo_id = ?", periodo_id).count > 0
	end

	def inscripciones_en_periodo_actual?
		self.inscripcionsecciones.where("secciones.periodo_id = ?", ParametroGeneral.periodo_actual_id).count > 0
	end

	def inscripciones_en_periodo_actual
		self.inscripcionsecciones.where("secciones.periodo_id = ?", ParametroGeneral.periodo_actual_id)
	end

	protected

	def set_to_upcase
		self.descripcion = self.descripcion.upcase
	end

end
