class Usuario < ApplicationRecord
	self.primary_key = :ci

	enum sexo: [:F, :M]

	attr_accessor :password_confirmation

	after_initialize :set_default_sexo_and_password, :if => :new_record?

	def set_default_sexo_and_password
		self.sexo ||= :F
		self.password ||= self.ci
	end

	has_one :administrador
	has_one :estudiante
	has_one :profesor

end
