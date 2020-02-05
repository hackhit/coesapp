class Restringida < ApplicationRecord
	GRUPOS = %w(Generales Inscripciones Calificaciones Horarios Usuarios Estructurales)

	has_many :autorizadas, dependent: :delete_all
	has_many :usuarios, through: :autorizadas

	validates :nombre_publico, presence: true

	enum grupo: GRUPOS 

end
