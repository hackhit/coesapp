class Asignatura < ApplicationRecord
  belongs_to :catedra
  belongs_to :departamento
end
