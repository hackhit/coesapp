class Departamento < ApplicationRecord

	# ASOCIACIONES:
	has_many :asignaturas
	accepts_nested_attributes_for :asignaturas

	has_many :profesores
	accepts_nested_attributes_for :profesores

	has_many :catedras_departamentos, class_name: 'CatedraDepartamento'
	accepts_nested_attributes_for :catedras_departamentos

	has_many :catedras, through: :catedras_departamentos, source: :catedra

	# VALIDACIONES
	validates :id, presence: true, uniqueness: true
	validates :descripcion, presence: true


end
