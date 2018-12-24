class Asignatura < ApplicationRecord
	belongs_to :catedra
	belongs_to :departamento

	has_many :secciones
	accepts_nested_attributes_for :secciones

	validates :id, presence: true, uniqueness: true
	validates_uniqueness_of :id_upsi, message: 'Código UXXI ya está en uso', field_name: false	
	validates_presence_of :id_upsi, message: 'Código UXXI requerido'	
	validates :descripcion, presence: true

	def descripcion_completa
		desc = "#{descripcion} "
		desc += "- #{catedra.descripcion}" if catedra
		desc += "- #{departamento.descripcion}" if departamento
		return desc
	end

	def descripcion_reversa
		desc = cal_departamento.descripcion if cal_departamento
		desc += "| #{catedra.descripcion}" if catedra		
		return desc
	end

end
