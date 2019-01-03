class Catedra < ApplicationRecord

	# ASOCIACIONES:
	has_many :asignaturas

	has_many :catedradepartamentos#, class_name: 'CatedraDepartamento'
	accepts_nested_attributes_for :catedradepartamentos

	has_many :departamentos, through: :catedradepartamentos, source: :departamento

	# VALIDAIONES:
	validates :id, presence: true, uniqueness: true
	validates :descripcion, presence: true
	# validates :orden, presence: true

end