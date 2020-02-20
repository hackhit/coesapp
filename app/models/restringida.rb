class Restringida < ApplicationRecord
	GRUPOS = %w(Generales Estructurales Informacionales Inscripciones Importaciones Usuarios Calificaciones Programaciones)
			#    0              1              2             3             4            5           6            7
	has_many :autorizadas, dependent: :delete_all
	has_many :usuarios, through: :autorizadas

	validates :nombre_publico, presence: true

	# has_many :perfiles_restringidas

	# has_many :perfiles,  through: :perfiles_restringidas

	enum grupo: GRUPOS 

end
