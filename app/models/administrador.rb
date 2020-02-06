class Administrador < ApplicationRecord

	# VARIABLES
	enum rol: [:ninja, :super, :admin_escuela, :admin_departamento, :taquilla]

	# TRIGGERS
	after_initialize :set_default_taquilla, if: :new_record?

	before_save :set_to_nil

	# ASOCIACIONES
	belongs_to :usuario, foreign_key: :usuario_id 

	belongs_to :departamento, optional: true

	belongs_to :escuela, optional: true

	has_many :bitacoras
	accepts_nested_attributes_for :bitacoras

	# VALIDACIONES
	validates :usuario_id,  presence: true, uniqueness: true
	validates :departamento_id,  presence: true, if: -> {self.admin_departamento?}
	validates :escuela_id,  presence: true, if: -> {self.admin_escuela?}

	def autorizado? *args
		usuario.autorizado? *args
	end

	def pertenece_a_escuela
		if self.escuela
			return self.escuela
		elsif self.departamento
			return self.departamento.escuela
		else
			return nil
		end
	end

	# FUNCIONES
	def asignaturas
		if self.escuela_id
			return Asignatura.where(escuela_id: self.escuela_id)
		elsif self.departamento_id 
			return Asignatura.where(escuela_id: self.departamento.escuela_id)
		else
			return Asignatura.all
		end
	end

	def planes
		if self.escuela_id
			return Plan.where(escuela_id: self.escuela_id)
		elsif self.departamento_id 
			return Plan.where(escuela_id: self.departamento.escuela_id)
		else
			return Plan.all
		end
	end

	def escuelas
		if self.escuela_id
			return Escuela.where(id: self.escuela_id)
		elsif self.departamento_id 
			return Escuela.where(id: self.departamento.escuela_id)
		else
			return Escuela.all
		end
	end

	def desc_rol
		if self.ninja?
			return "Maestro"
		elsif self.admin_escuela?
			return "Admin Esc. #{self.escuela_id.titleize}"
		elsif self.admin_departamento?
			return "Admin Dpto. #{self.departamento_id.capitalize} (#{self.departamento.escuela_id.capitalize})"
		else
			return self.rol.titleize
		end
	end

	def departamentos
		if self.admin_escuela? 
			self.escuela.departamentos
		elsif self.admin_departamento? 
			Departamento.where(id: departamento_id)
		else
			Departamento.all
		end
	end

	def catedras
		pdto_ids = self.departamentos.ids

		cds = Catedradepartamento.where(departamento_id: pdto_ids).collect{|cd| cd.catedra_id}

		Catedra.find cds

	end

	def maestros?
		self.ninja? or self.super?
	end

	def mas_altos?
		self.maestros? or self.admin_escuela?
	end

	def altos?
		self.mas_altos? or self.admin_departamento?
	end

	def descripcion
		aux = "#{usuario.descripcion} - #{rol.titleize}"
		aux += " (#{self.departamento.descripcion})" if self.departamento
		aux += " (#{self.escuela.descripcion})" if self.escuela
		return aux
	end

	def unico?
		id.eql? '15573230'
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
