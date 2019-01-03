class Departamento < ApplicationRecord

	# ASOCIACIONES:
	has_many :asignaturas
	accepts_nested_attributes_for :asignaturas

	has_many :profesores
	accepts_nested_attributes_for :profesores

	has_many :administradores
	accepts_nested_attributes_for :administradores

	has_many :catedradepartamentos#, class_name: 'CatedraDepartamento'
	accepts_nested_attributes_for :catedradepartamentos

	has_many :catedras, through: :catedradepartamentos, source: :catedra

	# VALIDACIONES
	validates :id, presence: true, uniqueness: true
	validates :descripcion, presence: true


end
