class Perfil < ApplicationRecord
	has_many :perfiles_restringidas, class_name: 'PerfilRestringida'

	has_many :restringidas,  through: :perfiles_restringidas
end
