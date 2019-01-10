class Escuela < ApplicationRecord

	# ASOCIACIONES
	has_many :departamentos
	accepts_nested_attributes_for :departamentos

	has_many :planes
	accepts_nested_attributes_for :planes

	has_many :estudiantes
	accepts_nested_attributes_for :estudiantes	

	has_many :administradores
	accepts_nested_attributes_for :administradores

	# TRIGGERS
	before_save :set_to_upcase

	protected

	def set_to_upcase
		self.descripcion = self.descripcion.upcase
	end

end
