class Bloquehorario < ApplicationRecord

  # CONSTANTES

  DIAS = %w(Lunes Martes Miércoles Jueves Viernes)
  # ASOCIACIONES

  belongs_to :profesor, optional: true
  belongs_to :horario

  validates_uniqueness_of :horario_id, scope: [:dia, :entrada], message: 'Ya existe un horario con una hora de entrada igual para la sección.', field_name: false
  validates_uniqueness_of :horario_id, scope: [:dia, :salida], message: 'Ya existe un horario con una hora de salida igual para la sección.', field_name: false

  enum dia: DIAS

  def self.format_time(hora)

  	hora = "#{hora}:00" unless hora.include? ':'
  	hora = "#{hora}m" if hora.include? 'p'  	
  	return hora
  end
end
