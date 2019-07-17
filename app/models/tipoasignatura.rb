class Tipoasignatura < ApplicationRecord
	# Relaciones:
	has_many :asignaturas

	PROYECTO = 'P'


	# Validaciones:
	validates :id, presence: true
	validates :descripcion, presence: true

	before_save :set_downcase_descripcion

	def set_downcase_descripcion
		self.descripcion = self.descripcion.downcase
	end
end
