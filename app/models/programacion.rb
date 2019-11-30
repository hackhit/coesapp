class Programacion < ApplicationRecord
  # ASOCIACIONES:
  belongs_to :asignatura
  belongs_to :periodo

  has_many :secciones, through: :asignatura, dependent: :delete_all 
  has_one :departamento, through: :asignatura 
  has_one :escuela, through: :departamento

  scope :pcis, -> {where("programaciones.pci IS TRUE")}
  scope :del_periodo, lambda {|periodo_id| where(periodo_id: periodo_id)}
  scope :de_la_escuela, lambda {|escuela_id| joins(:asignatura).joins(:departamento).where('escuela_id = ?', escuela_id)}
end
