class Programacion < ApplicationRecord
  # ASOCIACIONES:
  belongs_to :asignatura
  belongs_to :periodo

  scope :pcis, -> {where("pci IS TRUE")}
end
