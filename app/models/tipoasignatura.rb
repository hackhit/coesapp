class Tipoasignatura < ApplicationRecord
	# Relación
	has_many :asignaturas

	# Validación
	validate :id, presence: true
	validate :descripcion, presence: true

	before_save :set_downcase_descripcion

	def set_downcase_descripcion
		self.descripcion = self.descripcion.downcase
	end
end
