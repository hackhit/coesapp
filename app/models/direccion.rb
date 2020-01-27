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

	def descripcion_completa
		"#{estado} - #{municipio} - #{ciudad} - #{sector} - #{calle}, #{tipo_vivienda}: #{nombre_vivienda}"
	end


	def self.getIndexEstado estadoName
		estados = venezuela.map{|a| a["estado"]}
		estados.index(estadoName)
	end

	def self.getIndexMunicipio estadoName, municipioName
		indiceEstado = getIndexEstado estadoName
		venezuela[indiceEstado]["municipios"].map{|a| a["municipio"]}.index(municipioName)
	end

	def self.estados
		venezuela.map{|a| a["estado"]}
	end

	def self.municipios estadoName
		Direccion.venezuela[getIndexEstado(estadoName)]['municipios'].map{|a| a["municipio"]}.sort
	end

	def self.parroquias estadoName, municipioName
		indiceEstado = getIndexEstado(estadoName)
		indiceMunicipio = getIndexMunicipio(estadoName, municipioName)
      	venezuela[indiceEstado]["municipios"][indiceMunicipio]['parroquias'].map.sort
	end

    def self.venezuela
      require 'json'

      file = File.read("#{Rails.root}/public/venezuela.json")

      JSON.parse(file)
    end

end