class Usuario < ApplicationRecord
	# VARIABLES:
	self.primary_key = :ci
	enum sexo: [:Femenino, :Masculino]
	attr_accessor :password_confirmation

	# ASOCIACIONES:
	has_one :administrador
	has_one :estudiante
	has_one :profesor

	has_many :bitacoras
	accepts_nested_attributes_for :bitacoras

	# TRIGGERS:
	after_initialize :set_default_sexo, :if => :new_record?
	before_save :upcase_nombres

	# VALIDACIONES:
	validates :ci, presence: true, uniqueness: true
	validates :nombres, presence: true
	validates :apellidos, presence: true
	validates :sexo, presence: true
	validates :password, presence: true
	validates :password, confirmation: true

	# SCOPES:
	scope :search, lambda { |clave| 
		where("ci LIKE ? OR nombres LIKE ? OR apellidos LIKE ? OR ci LIKE ? OR email LIKE ?","%#{clave}%","%#{clave}%","%#{clave}%", "%#{clave}%", "%#{clave}%")
	}

	# scope :search, lambda { |clave| 
	# 	where("MATCH(ci, nombres, apellidos, email, telefono_habitacion, telefono_movil) AGAINST('#{clave}')")
	# }

	# FUNCIONES:

	def ultimo_plan
		estudiante ? estudiante.ultimo_plan : '--'
		
	end

	def admin?
		not self.administrador.nil?
	end

	def roles_generales
      aux = []
      aux << "Administrador" if administrador
      aux << "Profesor" if profesor
      aux << "Estudiante" if estudiante

      return aux		
	end

	def sexo_to_s
		aux = 'Mujer' if mujer?
		aux = 'Hombre' if hombre?
		return aux.blank? ? 'Indefinido' : aux
	end

	def mujer?
		return self.sexo.eql? 'Femenino'
	end

	def hombre?
		return self.sexo.eql? 'Masculino'
	end

	def la_el
		mujer? ? 'la' : 'el'
	end

	def genero
		gen = "@"
		gen = "a" if self.mujer?
		gen = "o" if self.hombre?
		return gen
	end

	def descripcion_contacto
		contacto = ""
		contacto += "Correo: #{email.to_s}" if email
		contacto += "| Movil: #{telefono_movil.to_s}" if telefono_movil
		contacto += "| Habitación: #{telefono_habitacion.to_s}" if telefono_habitacion
		contacto = "Sin Información" if contacto.blank?
		return contacto
	end

	def nickname
		aux = nombres.split[0]
		return (aux.size < 6) ? nombres : aux 
		
	end

	def nombre_completo
		if nombres and apellidos
			"#{nombres} #{apellidos}"
		else
			""
		end
	end

	def apellido_nombre
		if nombres and apellidos
			"#{apellidos}, #{nombres}"
		else
			""
		end

	end

	def roles
		aux = []
		aux << "#{administrador.desc_rol}" if administrador
		aux << "Estudiante" if estudiante
		aux << "Profesor (#{profesor.departamento.descripcion})" if profesor

		return aux
	end

	def descripcion
		"(#{ci}) #{nombre_completo}"
	end

	def descripcion_apellido
		"(#{ci}) #{apellido_nombre}"		
	end

	def self.autenticar(login,clave)
    	return Usuario.where(ci: login, password: clave).limit(1).first
  	end


	# FUNCIONES PROTEGIDAS:
	protected

	def upcase_nombres
		self.ci.strip!
		self.nombres.strip.upcase!
		self.apellidos.strip.upcase!
	end

	def set_default_password
		self.password ||= self.ci
	end

	def set_default_sexo
		self.sexo ||= :Femenino
	end


end
