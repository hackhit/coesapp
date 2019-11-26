class Horario < ApplicationRecord
	belongs_to :seccion

	has_many :bloquehorarios, dependent: :destroy
	accepts_nested_attributes_for :bloquehorarios

	validates :seccion_id, presence: true, uniqueness: true

	def descripcion_seccion
		"#{seccion.asignatura.id} (#{seccion.numero})"
	end


	def descripcion
		bloquehorarios.collect{|bh| "#{bh.dia[0..2]} de #{bh.entrada_descripcion} a #{bh.salida_descripcion} "}.to_sentence
	end

	def bloques_schedule
		bloquehorarios.collect{|bh| {day: Bloquehorario.dias[bh.dia], periods: [["#{bh.entrada_to_schedule}", "#{bh.salida_to_schedule}"]], title: descripcion_seccion, color: color} }
	end

	def transparencia_color valor
		unless color
			return ""
		else
			aux = color.split(",")
			aux[3] = "#{valor})"
			return aux
		end
	end

	# def bloques_schedule
	# 	bloquehorarios.collect{|bh| {day: Bloquehorario.dias[bh.dia], periods: {start: "#{bh.entrada_to_schedule}", end: "#{bh.salida_to_schedule}", title: descripcion_seccion, backgroundColor: color}}}
	# end

end
