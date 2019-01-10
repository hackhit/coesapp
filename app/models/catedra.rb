class Catedra < ApplicationRecord

	# ASOCIACIONES:
	has_many :asignaturas

	has_many :secciones, through: :asignaturas

	has_many :inscripcionsecciones, through: :secciones

	has_many :catedradepartamentos#, class_name: 'CatedraDepartamento'
	accepts_nested_attributes_for :catedradepartamentos

	has_many :departamentos, through: :catedradepartamentos, source: :departamento

	# VALIDAIONES:
	validates :id, presence: true, uniqueness: true
	validates :descripcion, presence: true
	# validates :orden, presence: true

	# TRIGGERS
	before_save :set_to_upcase

	def descripcion_completa
		"#{self.descripcion.titleize} (#{departamento.descripcion_completa})"
	end

	protected

	def set_to_upcase
		self.descripcion = self.descripcion.upcase
	end
end