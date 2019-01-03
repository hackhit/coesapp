class Administrador < ApplicationRecord

	# VARIABLES
	enum rol: [:super, :jefe_departamento, :operador]

	# TRIGGERS
	after_initialize :set_default_operador, if: :new_record?

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
	def altos?
		self.super? or self.jefe_departamento?
	end

	def descripcion
		"#{usuario.descripcion} - #{rol.titleize}"
	end
	
	protected


	def set_default_operador
		self.rol ||= :operador
	end



end
