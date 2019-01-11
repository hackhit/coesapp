class Seccion < ApplicationRecord

	# ASOCIACIONES:
	belongs_to :asignatura
	belongs_to :periodo
	belongs_to :tipo_seccion
	belongs_to :profesor, optional: true 

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

    # SCOPES:
	scope :calificadas, -> {where "calificada IS TRUE"}
	scope :sin_calificar, -> {where "calificada IS FALSE"}
	scope :del_periodo, lambda { |periodo_id| where "periodo_id = ?", periodo_id}
	scope :del_periodo_actual, -> { where "periodo_id = ?", ParametroGeneral.periodo_actual_id}


	# FUNCIONES:
	def total_estudiantes
		inscripcionsecciones.count
	end

	def total_confirmados
		inscripcionsecciones.confirmados.count
	end

	def total_aprobados
		inscripcionsecciones.aprobados.count
	end

	def total_reprobados
		inscripcionsecciones.reprobados.count
	end

	def total_perdidos
		inscripcionsecciones.perdidos.count
	end

	def total_sin_calificar
		inscripcionsecciones.sin_calificar.count
	end

	def descripcion
		descripcion = ""
		descripcion += asignatura.descripcion if asignatura
		
		if numero
			if self.suficiencia?
				descripcion += " (Suficiencia)"
			elsif self.reparacion?
				descripcion += " (Reparación)"
			else
				descripcion += " - #{numero}"
			end
		end 
		return descripcion
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

	def reparacion?
		return numero.include? 'R'
	end


	def suficiencia?
		return numero.include? 'S'
	end

	def tipo_convocatoria
		aux = numero[0..1]
		if reparacion?
			aux = "RA2" #{aux}"
		else
			aux = "FA2" #"F#{aux}"
		end
		return aux
	end

	def acta_no
		"#{self.seccion.asignatura.id_uxxi}#{self.seccion.numero}#{self.periodo_id}"
	end

	# FUNCIONES PROTEGIDAS

end
