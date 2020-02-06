class Periodo < ApplicationRecord
	# ENUMERADAS CONSTANTES
	enum tipo: [:semestral, :anual, :unico, :intensivo]

	# ASOCIACIONES:
	has_many :programaciones, dependent: :destroy
	has_many :asignaturas, through: :programaciones
	
	has_many :secciones
	accepts_nested_attributes_for :secciones

	has_many :inscripcionsecciones, through: :secciones#, source: :estudiantes

	has_many :escuelaperiodos
	accepts_nested_attributes_for :escuelaperiodos
	has_many :escuelas, through: :escuelaperiodos

	has_many :asignaturas, through: :escuelas#, source: :estudiantes
	
	# scope :anuales, ->{where("periodos.id LIKE '%A'")}
	# scope :semestrales, -> {where("periodos.id LIKE '%S' || periodos.id LIKE '%U'")}

	# default_scope { order(id: :desc) }

	# VALIDACIONES:
    validates :id, presence: true, uniqueness: true
    validates :inicia, presence: true#, uniqueness: true

	# FUNCIONES:

	def inscripciones
		inscripcionsecciones
	end

	# def anual?
	# 	id.include? 'A'
	# end

	# def semestral?
	# 	id.include? 'S' or id.include? 'U'
	# end

	def getPeriodoLectivo
		if self.anual?
			return '0'
		else
			return getParcial
		end

	end

	def getParcial
		"#{id.last(2).first}"
	end

	def letra_final_de_id
		id.last.upcase
	end

	def descripcion_filtro
		self.id
	end

	def tiene_secciones?
		secciones.count > 0 		
	end

	def tipo_a_letra
		tipo.to_s[0].upcase
	end

	def periodo_del_anno
		"#{id.split('-').last[0..1]}"
	end

	def valor_para_tipo_convocatoria
		"#{tipo_a_letra}#{periodo_del_anno.to_i}"
	end

	def anno
		"#{id.split('-').first}"
	end

	def periodo_anterior
		todos = Periodo.all.order(inicia: :asc)
		indice = todos.index self
		indice -= 1
		indice = 0 if indice < 0
		
		return todos[indice]
	end


end
