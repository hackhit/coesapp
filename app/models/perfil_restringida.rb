class PerfilRestringida < ApplicationRecord
	# SET GLOBALES:
	self.table_name = 'perfiles_restringidas'

	belongs_to :perfil
	belongs_to :restringida

	# validates_uniqueness_of :catedra_id, scope: [:departamento_id], message: 'Combinación Cátedra-Departamento ya existe', field_name: false
	
	# validates :orden,  presence: true

end
