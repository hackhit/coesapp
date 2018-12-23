class Administrador < ApplicationRecord

	enum rol: [:operador, :jefe_catadra, :jefe_departamento, :super]

	after_initialize :set_default_operador, :if => :new_record?

	def set_default_operador
		self.rol ||= :operador
	end

	belongs_to :usuario, foreign_key: :usuario_id 
	accepts_nested_attributes_for :usuario


end
