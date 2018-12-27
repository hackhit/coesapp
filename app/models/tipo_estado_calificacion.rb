class TipoEstadoCalificacion < ApplicationRecord

	# ASOCIACIONES:
	has_many :inscripciones_en_secciones
	accepts_nested_attributes_for :inscripciones_en_secciones

	# VALIDACIONES:
    validates :id, presence: true, uniqueness: true

end
