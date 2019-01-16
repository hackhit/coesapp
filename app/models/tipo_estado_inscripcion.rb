class TipoEstadoInscripcion < ApplicationRecord

	RETIRADA = 'RET'
	# ASOCIACIONES:
	has_many :inscripcionsecciones
	accepts_nested_attributes_for :inscripcionsecciones

	# VALIDACIONES:
    validates :id, presence: true, uniqueness: true

end
