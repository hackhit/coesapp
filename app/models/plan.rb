class Plan < ApplicationRecord

	# ASOCIACIONES:
	has_many :historialplanes
	accepts_nested_attributes_for :historialplanes

	belongs_to :escuela

	has_many :estudiantes, through: :historialplanes, source: :estudiante

	# VALIDACIONES:
    validates :id, presence: true, uniqueness: true
    validates :escuela_id, presence: true

    #TRIGGERS
    before_save :set_to_upcase

	# FUNCIONES:
	def descripcion_completa
		"#{id} - #{descripcion.titleize}"
	end

	# FUNCIONES PROTEGIDAS
	protected

	def set_to_upcase
		self.descripcion = self.descripcion.upcase
	end
end
