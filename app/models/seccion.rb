class Seccion < ApplicationRecord

	# ASOCIACIONES:
	belongs_to :asignatura
	belongs_to :periodo
	belongs_to :profesor

	has_many :inscripciones_en_secciones,
		class_name: 'InscripcionEnSeccion', dependent: :delete_all
	accepts_nested_attributes_for :inscripciones_en_secciones
	has_many :estudiantes, through: :inscripciones_en_secciones, source: :estudiante

	has_many :secciones_profesores_secundarios,
		:class_name => 'SeccionProfesorSecundario'
	accepts_nested_attributes_for :secciones_profesores_secundarios
	has_many :profesores, through: :secciones_profesores_secundarios, source: :profesor

    # VALIDACIONES:
    validates :usuario_id, presence: true, uniqueness: true

    # SCOPES:
	scope :calificadas, -> {where "calificada IS TRUE"}
	scope :sin_calificar, -> {where "calificada IS FALSE"}
	scope :del_periodo, lambda { |periodo_id| where "periodo_id = ?", periodo_id}
	scope :del_periodo_actual, -> { where "periodo_id = ?", ParametroGeneral.periodo_actual_id}


	# FUNCIONES:
	def total_estudiantes
		inscripciones_en_secciones.count
	end

	def total_confirmados
		inscripciones_en_secciones.confirmados.count
	end

	def total_aprobados
		inscripciones_en_secciones.aprobados.count
	end

	def total_reprobados
		inscripciones_en_secciones.reprobados.count
	end

	def total_perdidos
		inscripciones_en_secciones.perdidos.count
	end

	def total_sin_calificar
		inscripciones_en_secciones.sin_calificar.count
	end

	def descripcion
		descripcion = ""
		descripcion += asignatura.descripcion if asignatura
		
		if numero
			if numero.eql? "S"
				descripcion += " (Suficiencia)"
			elsif numero.eql? "R"
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


end
