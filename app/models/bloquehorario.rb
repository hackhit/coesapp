class Bloquehorario < ApplicationRecord

  # CONSTANTES

  DIAS = %w(Lunes Martes Miércoles Jueves Viernes)
  # ASOCIACIONES

  belongs_to :profesor, optional: true
  belongs_to :horario

  validates_uniqueness_of :horario_id, scope: [:dia, :entrada], message: 'Ya existe un horario con una hora de entrada igual para la sección.', field_name: false
  validates_uniqueness_of :horario_id, scope: [:dia, :salida], message: 'Ya existe un horario con una hora de salida igual para la sección.', field_name: false

  validates :entrada, presence: true
  validates :salida, presence: true
  validates :dia, presence: true

  enum dia: DIAS

  def entrada_to_schedule
    if entrada
      return (entrada-(7.hours)).strftime '%H:%M'
    else
      return ""
    end
  end

  def salida_to_schedule
    if salida
      return (salida-(7.hours)).strftime '%H:%M'
    else
      return ""
    end
  end

  def self.format_time(hora)

  	if hora.include? 'p'
      hora.remove!('p')
      hora = "#{hora}:00" unless hora.include? ':'
      hora = "#{hora}pm"
    else
      hora = "#{hora}:00" unless hora.include? ':'
    end  
  	return hora
  end
end
