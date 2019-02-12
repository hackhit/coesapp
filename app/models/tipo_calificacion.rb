class TipoCalificacion < ApplicationRecord

	REPARACION = 'NR'
	DIFERIDO = 'ND'
	FINAL = 'NF'
	PI = 'PI'
	# ASOCIACIONES:
	has_many :inscripcionsecciones
	accepts_nested_attributes_for :inscripcionsecciones

	# VALIDACIONES:
	validates :id, presence: true, uniqueness: true

end
