class Administrador < ApplicationRecord

	# VARIABLES
	enum rol: [:ninja, :super, :jefe_facultad, :jefe_catadra, :jefe_departamento, :operador]

	# TRIGGERS
	after_initialize :set_default_operador, :if => :new_record?

	# ASOCIACIONES
	belongs_to :usuario, foreign_key: :usuario_id 
	accepts_nested_attributes_for :usuario

	# VALIDACIONES
	validates :usuario_id,  :presence => true, uniqueness: true

	# FUNCIONES
	def super_admin?
		return (rol and rol.eql? :super)
	end

	# FUNCIONES PROTEGIDAS
	protected

	def set_default_operador
		self.rol ||= :operador
	end



end
