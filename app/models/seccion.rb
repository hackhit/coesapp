class Seccion < ApplicationRecord
  belongs_to :asignatura
  belongs_to :periodo
  belongs_to :profesor
end
