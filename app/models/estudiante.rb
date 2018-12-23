class Estudiante < ApplicationRecord

	belongs_to :usuario, foreign_key: :usuario_id 
	accepts_nested_attributes_for :usuario

end
