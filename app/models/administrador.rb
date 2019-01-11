class Administrador < ApplicationRecord

	# VARIABLES
	enum rol: [:super, :admin_escuela, :admin_departamento, :taquilla]

	# TRIGGERS
	after_initialize :set_default_taquilla, if: :new_record?

	before_save :set_to_nil

	# ASOCIACIONES
	belongs_to :usuario, foreign_key: :usuario_id 

	belongs_to :departamento, optional: true

	belongs_to :escuela, optional: true

	# VALIDACIONES
	validates :usuario_id,  presence: true, uniqueness: true
	validates :departamento_id,  presence: true, if: -> {self.admin_departamento?}
	validates :escuela_id,  presence: true, if: -> {self.admin_escuela?}

	# FUNCIONES
	def escuelas
		if self.super?
			return Escuela.all
		elsif self.admin_escuela? 
			return Escuela.where(id: self.escuela_id)
		else
			return Escuela.where(id: self.departamento.escuela_id)
		end
		
	end

	def departamentos
		if self.escuela_id
			self.escuela.departamentos
		elsif self.departamento_id
			Departamento.where(id: departamento_id)
		else
			Departamento.all
		end
	end

	def altos?
		self.super? or self.admin_escuela? 
	end

	def descripcion
		aux = "#{usuario.descripcion} - #{rol.titleize}"
		aux += " (#{self.departamento.descripcion})" if self.departamento
		aux += " (#{self.escuela.descripcion})" if self.escuela
		return aux
	end

	def puede_escribir?
		!self.taquilla?
	end
	
	# FUNCIONES PROTEGIDAS
	protected
	def set_default_taquilla
		self.rol ||= :taquilla
	end
	def set_to_nil
		self.departamento_id = nil if self.departamento_id.blank?
		self.escuela_id = nil if self.escuela_id.blank?
	end
end
