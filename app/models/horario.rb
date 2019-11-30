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

	def color_rgb_to_hex intensidad = nil
		if color.blank?
			"101010"
		else
			r,g,b = color.split(",")
			r = r.split("(")[1]

			if intensidad
				r = r.to_i*intensidad
				g = g.to_i*intensidad
				b = b.to_i*intensidad

				r = 235 if r > 235
				g = 235 if g > 235
				b = 235 if b > 235
			end

			"#{toHex r}#{toHex g}#{toHex b}"
		end
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

	private
	def toHex c
		aux = c.to_i.to_s(16)
		return (aux.length.eql? 1) ? "0#{aux}" : aux
	end
	# def bloques_schedule
	# 	bloquehorarios.collect{|bh| {day: Bloquehorario.dias[bh.dia], periods: {start: "#{bh.entrada_to_schedule}", end: "#{bh.salida_to_schedule}", title: descripcion_seccion, backgroundColor: color}}}
	# end

end
