class Horario < ApplicationRecord
	belongs_to :seccion

	has_many :bloquehorarios
	accepts_nested_attributes_for :bloquehorarios

	validates :seccion_id, presence: true, uniqueness: true

end
