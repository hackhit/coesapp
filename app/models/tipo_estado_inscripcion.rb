class TipoEstadoInscripcion < ApplicationRecord


	INSCRITO = 'INS'
	REINCORPODADO = 'REINC'
	RETIRADA = 'RET'
	# ASOCIACIONES:
	has_many :inscripcionperiodos
	accepts_nested_attributes_for :inscripcionperiodos
	has_many :inscripcionsecciones
	accepts_nested_attributes_for :inscripcionsecciones

	# VALIDACIONES:
    validates :id, presence: true, uniqueness: true

end
