class Programacion < ApplicationRecord
  # ASOCIACIONES:
  belongs_to :asignatura
  belongs_to :periodo

  has_many :secciones, through: :asignatura 

  scope :pcis, -> {where("programaciones.pci IS TRUE")}
  scope :del_periodo, lambda {|periodo_id| where(periodo_id: periodo_id)}
end
