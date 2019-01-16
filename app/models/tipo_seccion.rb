class TipoSeccion < ApplicationRecord
	DIFERIDA = 'ND'

	# ASOCIACIONES
	has_many :secciones
	accepts_nested_attributes_for :secciones

	# VALIDACIONES
	validates :id, presence: true, uniqueness: true
	validates :descripcion, presence: true

	def diferida?
		self.id.eql? DIFERIDA
	end

end
