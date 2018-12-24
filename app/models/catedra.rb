class Catedra < ApplicationRecord

	has_many :asignaturas
	has_many :catedras_departamentos,
	accepts_nested_attributes_for :catedras_departamentos

	has_many :departamentos, through: :catedras_departamentos, source: :departamento

end