class Escuela < ApplicationRecord

	# ASOCIACIONES
	has_many :grados
	has_many :estudiantes, through: :grados

	has_many :departamentos
	accepts_nested_attributes_for :departamentos
	
	has_many :inscripciones_pci, class_name: 'Inscripcionseccion', foreign_key: 'pci_escuela_id'

	has_many :asignaturas, through: :departamentos
	
	has_many :profesores, through: :departamentos

	has_many :secciones, through: :asignaturas

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

	#FUNCTIONS

	def self.actualizar_parciales_201802A
		e = Escuela.find 'IDIO'
		ss = e.secciones.calificadas.del_periodo ('2018-02A')
		p ss.count

		ss.each do |s|
			s.inscripcionsecciones.where("(estado = 1 || estado = 2) && tipo_calificacion_id != 'PI'").each do |i|
				i.segunda_calificacion = nil
				i.tercera_calificacion = nil
				i.calificacion_final = nil
				i.estado = :trimestre1
				i.tipo_calificacion_id = TipoCalificacion::PARCIAL
				i.save
			end
			s.calificada = false
			s.abierta = true
			s.save
		end
	end

	def descripcion_filtro
		self.descripcion.titleize
	end

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
