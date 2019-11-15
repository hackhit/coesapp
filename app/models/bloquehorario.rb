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

  def descripcion_corta_para_asignaturas
    aux = "#{horario.seccion.numero}"
    aux += ": #{profesor.usuario.nombres}" if profesor
    return aux
  end

  def hora_descripcion hora
    if hora
      if (hora.strftime '%M').eql? '00'
        return (hora).strftime '%I%P'
      else
        return (hora).strftime '%I:%M%P'
      end
    else
      return ""
    end
  end

  def entrada_descripcion
    hora_descripcion entrada
  end

  def salida_descripcion
    hora_descripcion salida
  end

  def hora_to_schedule hora
    if hora
      return (hora-(7.hours)).strftime '%H:%M'
    else
      return ""
    end
    
  end

  def entrada_to_schedule
    hora_to_schedule entrada
  end

  def salida_to_schedule
    hora_to_schedule salida
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
