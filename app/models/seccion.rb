class Seccion < ApplicationRecord

	# ASOCIACIONES:
	belongs_to :asignatura
	belongs_to :periodo
	belongs_to :tipo_seccion
	belongs_to :profesor, optional: true 
	has_one :escuela, through: :asignatura

	has_many :inscripcionsecciones, dependent: :delete_all
	accepts_nested_attributes_for :inscripcionsecciones
	has_many :estudiantes, through: :inscripcionsecciones, source: :estudiante

	has_many :secciones_profesores_secundarios,
		:class_name => 'SeccionProfesorSecundario'
	accepts_nested_attributes_for :secciones_profesores_secundarios
	has_many :profesores, through: :secciones_profesores_secundarios, source: :profesor

    # VALIDACIONES:
    validates :asignatura_id, presence: true
    # validates :profesor_id, presence: true, if: :new_record?
    validates :periodo_id, presence: true
    validates :numero, presence: true
	validates_uniqueness_of :numero, scope: [:periodo_id, :asignatura_id], message: 'La sección ya existe, inténtalo de nuevo!', field_name: false

	before_create :default_values

    # SCOPES:
	scope :calificadas, -> {where "calificada IS TRUE"}
	scope :sin_calificar, -> {where "calificada IS NOT TRUE"}
	scope :del_periodo, lambda { |periodo_id| where "periodo_id = ?", periodo_id}
	# scope :del_periodo_actual, -> { where "periodo_id = ?", ParametroGeneral.periodo_actual_id}


	# FUNCIONES:

	def cerrada?
		!self.abierta
	end

	def abierta?
		abierta
	end

	def capacidad_vs_inscritos
		"#{self.capacidad} / #{total_estudiantes}"
	end

	def calificada_valor
		self.calificada ? 'Sí' : 'No'
	end

	def total_estudiantes
		inscripcionsecciones.count
	end

	def total_confirmados
		inscripcionsecciones.confirmados.count
	end

	def total_aprobados
		inscripcionsecciones.aprobado.count
	end

	def total_reprobados
		inscripcionsecciones.aplazado.count
	end

	def total_perdidos
		inscripcionsecciones.perdidos.count
	end

	def total_sin_calificar
		inscripcionsecciones.sin_calificar.count
	end


	def descripcion_con_uxxi periodo_id=nil
		descrip = descripcion(periodo_id)
		"(#{asignatura.id_uxxi}) - #{descrip}"
	end


	def descripcion periodo_id=nil
		descrip = ""
		if periodo_id
			descrip += self.asignatura.descripcion_pci(periodo_id) if self.asignatura
		else
			descrip += self.asignatura.descripcion if self.asignatura
		end
		
		if numero
			if self.suficiencia?
				descrip += " (Suficiencia)"
			else
				descrip += " - #{numero}"
			end
		end 
		return descrip
	end

	def descripcion_profesor_asignado
		if profesor
			profesor.descripcion_usuario
		else
			"No asignado"
		end
	end

	def ejercicio
		"#{periodo_id}"
	end

	def r_or_f?
		if numero.include? 'R'
			return 'R'
		else 
			'F'
		end
	end

	# end


	def suficiencia?
		# return numero.include? 'S'
		self.tipo_seccion_id.eql? TipoSeccion::SUFICIENCIA
	end

	# def tipo_convocatoria
	# 	aux = numero[0..1]
	# 	if reparacion?
	# 		aux = "RA2" #{aux}"
	# 	else
	# 		aux = "FA2" #"F#{aux}"
	# 	end
	# 	return aux
	# end

	def acta_no
		"#{self.seccion.asignatura.id_uxxi}#{self.seccion.numero}#{self.periodo_id}"
	end

	# FUNCIONES PROTEGIDAS

	protected

	def default_values
		self.tipo_seccion_id ||= 'NF'
		self.calificada ||= false
	end

end
