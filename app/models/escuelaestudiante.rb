class Escuelaestudiante < ApplicationRecord
  # ASOCIACIONES:
  belongs_to :escuela
  belongs_to :estudiante

end
