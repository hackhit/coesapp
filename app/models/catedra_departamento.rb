class CatedraDepartamento < ApplicationRecord
	# SET GLOBALES:
	self.table_name = 'catedras_departamentos'

	belongs_to :departamento
	belongs_to :catedra

	validates_uniqueness_of :catedra_id, scope: [:departamento_id], message: 'Combinación Cátedra-Departamento ya existe', field_name: false
	
	validates :orden,  :presence => true

end
