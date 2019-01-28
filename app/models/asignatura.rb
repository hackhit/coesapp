class Asignatura < ApplicationRecord

	# ASOCIACIONES:
	belongs_to :catedra
	belongs_to :departamento
	belongs_to :tipoasignatura
	# belongs_to :catedra_departamento, class_name: 'CatedraDepartamento', foreign_key: [:catedra_id, :departamento_id], primary_key: [:catedra_id, :departamento_id]

	# ENUMERADAS CONSTANTES
	enum calificacion: [:numerica, :absoluta]

	has_many :secciones
	accepts_nested_attributes_for :secciones

	# VALIDACIONES:
	validates :id, presence: true, uniqueness: true
	validates_uniqueness_of :id_uxxi, message: 'Código UXXI ya está en uso', field_name: false	
	validates_presence_of :id_uxxi, message: 'Código UXXI requerido'	
	validates :descripcion, presence: true
	validates :calificacion, presence: true
	# validates :anno, presence: true
	# validates :orden, presence: true
	validates :catedra_id, presence: true
	validates :departamento_id, presence: true
	validates :tipoasignatura_id, presence: true

	# SCOPE

	scope :activas, -> {where "activa IS TRUE"}

	# TRIGGGERS:
	before_save :set_uxxi_how_id
	before_save :set_to_upcase

	# FUNCIONES:

	def activa?
		return self.activa #self.activa.eql? true ? true : false
	end
	def descripcion_completa
		"#{descripcion.titleize} - #{catedra.descripcion_completa} - #{departamento.descripcion_completa}"
	end

	def descripcion_reversa
		desc = cal_departamento.descripcion if cal_departamento
		desc += "| #{catedra.descripcion.titleize}" if catedra		
		return desc
	end

	# FUNCIONES PROTEGIDAS:
	protected
	
	def set_uxxi_how_id
		self.id ||= self.id_uxxi
	end

	def set_to_upcase
		self.descripcion = self.descripcion.strip.upcase
	end
end
