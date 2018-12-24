class Departamento < ApplicationRecord

	has_many :asignaturas

	accepts_nested_attributes_for :asignaturas

	has_many :profesores
	accepts_nested_attributes_for :profesores

	has_many :catedras_departamentos,

	accepts_nested_attributes_for :catedras_departamentos

	has_many :categorias, through: :catedras_departamentos, source: :categoria


end
