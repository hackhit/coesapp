class Administrador < ApplicationRecord

	# VARIABLES
	enum rol: [:super, :jefe_departamento, :taquilla]

	# TRIGGERS
	after_initialize :set_default_taquilla, if: :new_record?

	before_save :set_dpto_to_nil

	# ASOCIACIONES
	belongs_to :usuario, foreign_key: :usuario_id 
	accepts_nested_attributes_for :usuario

	belongs_to :departamento, optional: true
	accepts_nested_attributes_for :departamento

	# VALIDACIONES
	validates :usuario_id,  presence: true, uniqueness: true
	validates :departamento_id,  presence: true, if: -> {self.jefe_departamento?}

	# FUNCIONES

	# FUNCIONES PROTEGIDAS
	def set_dpto_to_nil
		self.departamento_id = nil if self.departamento_id.blank?
	end

	def altos?
		self.super? or self.jefe_departamento?
	end

	def descripcion
		"#{usuario.descripcion} - #{rol.titleize}"
	end
	
	protected


	def set_default_taquilla
		self.rol ||= :taquilla
	end



end
