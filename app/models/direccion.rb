class Direccion < ApplicationRecord
	belongs_to :estudiante, foreign_key: :estudiante_id 

	# VALIDACIONES:
	validates :estudiante_id, presence: true, uniqueness: true
	validates :estado, presence: true
	validates :municipio, presence: true
	validates :ciudad, presence: true
	validates :sector, presence: true
	validates :calle, presence: true
	validates :tipo_vivienda, presence: true
	validates :nombre_vivienda, presence: true
	validates :numero_vivienda, presence: true

	def descripcion_completa
		"#{estado} - #{municipio} - #{ciudad} - #{sector} - #{calle}, #{tipo_vivienda}: #{nombre_vivienda} (#{numero_vivienda})"
	end

end