class Seccion < ApplicationRecord
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

	scope :calificadas, -> {where "calificada IS TRUE"}
	scope :sin_calificar, -> {where "calificada IS FALSE"}
	scope :del_periodo, lambda { |periodo_id| where "periodo_id = ?", periodo_id}
	scope :del_periodo_actual, -> { where "periodo_id = ?", ParametroGeneral.periodo_actual_id}


end
