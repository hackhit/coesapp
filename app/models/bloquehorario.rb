class Bloquehorario < ApplicationRecord

  # CONSTANTES

  DIAS = %w(Lunes Martes Miércoles Jueves Viernes)
  # ASOCIACIONES

  belongs_to :profesor, optional: true
  belongs_to :horario
  has_one :seccion, through: :horario
  has_one :periodo, through: :seccion


  validates_uniqueness_of :horario_id, scope: [:dia, :entrada], message: 'Ya existe un horario con una hora de entrada igual para la sección.', field_name: false
  validates_uniqueness_of :horario_id, scope: [:dia, :salida], message: 'Ya existe un horario con una hora de salida igual para la sección.', field_name: false

  validates :entrada, presence: true
  validates :salida, presence: true
  validates :dia, presence: true

  enum dia: DIAS


  # def self.printHorario
  #   data = Bloquehorario::DIAS
  #   data.unshift("")
  #   data.map!{|a| "<b>"+a[0..2]+"</b>"}
  #   data = [data]

  #   for i in 7..14 do
  #     p "valor de i: #{i}"
  #     for j in 0..3 do

  #       aux = ["#{i.to_s}:#{sprintf("%02i", (j*15))}"]

  #       Bloquehorario::DIAS.each do |dia|
  #         aux << 
  #       end        
  #       # data << ["#{i.to_s}:#{sprintf("%02i", (j*15))}","","","","",""] # En blanco


  #     end
  #   end
  #   return data
  # end


  def descripcion_seccion_para_profesores
    aux =  profesor ? "#{profesor.descripcion_usuario} <br>" : ""
    aux += " #{horario.descripcion_seccion} : #{horario.seccion.asignatura.descripcion}"
    return aux
  end

  def desc_profe_ocupado
    unless profesor
      ""
    else

      "#{profesor.usuario.nombres} está ocupad#{profesor.usuario.genero} en éste horario con #{horario.seccion.numero} de #{horario.seccion.asignatura_id}" 
    end
  end

  def desc_to_asig
    aux = ""
    aux += "#{profesor.usuario.nombres}" if profesor
    return aux
  end

  def mismo_bloque? horario_id
    aux = Horario.find horario_id

    bloquesOrigen = aux.bloquehorarios.map{|bh| bh.dia_con_entrada}

    bloquesOrigen.include? dia_con_entrada
  end

  def dia_con_entrada
    "#{dia} #{entrada_descripcion}"    
  end

  def entrada_descripcion
    Bloquehorario.hora_descripcion entrada
  end

  def salida_descripcion
    Bloquehorario.hora_descripcion salida
  end

  def self.hora_descripcion hora
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
