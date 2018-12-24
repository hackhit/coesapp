class Estudiante < ApplicationRecord

	belongs_to :usuario, foreign_key: :usuario_id 
	accepts_nested_attributes_for :usuario

	has_many :historiales_planes,
	class_name: 'EstudiantePlan'#, foreign_key: :estudiante_id

	accepts_nested_attributes_for :historiales_planes

	has_many :planes, through::historiales_planes, source::plan

	has_many :inscripciones_en_secciones,
		class_name: 'CalEstudianteSeccion'
	accepts_nested_attributes_for :inscripciones_en_secciones
	
	has_many :secciones, through: :inscripciones_en_secciones, source: :seccion

end
