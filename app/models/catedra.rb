class Catedra < ApplicationRecord

	# ASOCIACIONES:
	has_many :asignaturas
	has_many :catedras_departamentos, class_name: 'CatedraDepartamento'
	accepts_nested_attributes_for :catedras_departamentos

	has_many :departamentos, through: :catedras_departamentos, source: :departamento

	# VALIDAIONES:
	validates :id, presence: true, uniqueness: true
	validates :descripcion, presence: true
	validates :orden, presence: true

end