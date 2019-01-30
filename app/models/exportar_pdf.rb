
class ExportarPdf
	include Prawn::View


	def self.hacer_constancia_estudio estudiante_ci, periodo_id
		# Variable Locales
		estudiante = Estudiante.find estudiante_ci

 		inscripciones = estudiante.inscripcionsecciones.del_periodo periodo_id
		# total_creditos = secciones.joins(:cal_materia).sum("cal_materia.creditos")

		pdf = Prawn::Document.new(top_margin: 20)

		#titulo
		encabezado_central_con_logo pdf, "CONSTANCIA DE ESTUDIO"

		pdf.move_down 5

		# pdf.start_page_numbering(50, 800, 500, nil, "<b><PAGENUM>/<TOTALPAGENUM></b>", 1)

		pdf.text "Quien suscribe, Jefe de Control de Estudios de la Facultad de HUMANIDADES Y EDUCACIÓN, de la Escuela de #{estudiante.escuela.descripcion.upcase} de la Universidad Central de Venezuela, por medio de la presente hace constar que el BR. <b>#{estudiante.usuario.apellido_nombre}</b>, titular de la Cédula de Identidad <b>#{estudiante.id}</b> es estudiante regular de esta escuela y esta cursando en el periodo <b>#{periodo_id}</b>; las siguientes asignatura:", size: 10, inline_format: true, align: :justify

		pdf.move_down 20

		data = [["<b>Código</b>", "<b>Asignatura</b>", "<b>Sección</b>", "<b>Créditos</b>", "<b>Estado</b>"]]

		total_creditos = 0

		inscripciones.each do |inscripcion|
			seccion = inscripcion.seccion
			asignatura = seccion.asignatura
			total_creditos += asignatura.creditos
			data << [asignatura.id_uxxi,
				asignatura.descripcion.titleize,
				seccion.numero,
				asignatura.creditos,
				inscripcion.tipo_estado_inscripcion.descripcion]
		end
		
		t = pdf.make_table(data, header: true, row_colors: ["F0F0F0", "FFFFFF"], width: 540, position: :center, cell_style: { inline_format: true, size: 9, align: :center, padding: 3, border_color: '818284'}, :column_widths => {1 => 160})
		t.draw

		pdf.move_down 20

		data = [["<b>Clave</b>", "<b>Créditos</b>", "<b>Estado</b>"]]

		data << ["<i>Número total de créditos matriculados:</i>", total_creditos, ""]

		t = pdf.make_table(data, header: true, row_colors: ["F0F0F0", "FFFFFF"], width: 540, position: :center, cell_style: { inline_format: true, size: 9, align: :center, padding: 3, border_color: '818284'}, :column_widths => {1 => 160})
		t.draw

		pdf.move_down 20

      	pdf.text "Constancia que se expide a solicitud de la parte interesada en la Ciudad Universitaria en Caracas, el día #{I18n.l(Time.new, format: "%d de %B de %Y")}.", size: 10
		pdf.move_down 30
		pdf.text "<b> --Válida para el período actual--</b>", size: 11, inline_format: true, align: :center
		pdf.move_down 50

		pdf.text "Prof. Pedro Coronado", size: 11, align: :center
		pdf.text "Jef(a) de Control de Estudio", size: 11, align: :center

		return pdf
	end



	def self.hacer_constancia_inscripcion estudiante_ci, periodo_id
		# Variable Locales
		estudiante = Estudiante.find estudiante_ci

 		inscripciones = estudiante.inscripcionsecciones.del_periodo periodo_id
		# total_creditos = secciones.joins(:cal_materia).sum("cal_materia.creditos")

		pdf = Prawn::Document.new(top_margin: 20)

		#titulo
		encabezado_central_con_logo pdf, "CONSTANCIA DE INSCRIPCIÓN"

		pdf.move_down 5

		# pdf.start_page_numbering(50, 800, 500, nil, "<b><PAGENUM>/<TOTALPAGENUM></b>", 1)

		pdf.text "Quien suscribe, Jefe de Control de Estudios de la Facultad de HUMANIDADES Y EDUCACIÓN, de la Escuela de <b>#{estudiante.escuela.descripcion.upcase}</b> de la Universidad Central de Venezuela, por medio de la presente hace constar que el BR. <b>#{estudiante.usuario.apellido_nombre}</b>, titular de la Cédula de Identidad <b>#{estudiante.id}</b> esta inscrito en esta Escuela para el período <b>#{periodo_id}</b>; con las siguientes asignatura:", size: 10, inline_format: true, align: :justify

		pdf.move_down 20

		data = [["<b>Código</b>", "<b>Asignatura</b>", "<b>Sección</b>", "<b>Créditos</b>", "<b>Estado</b>"]]

		total_creditos = 0

		inscripciones.each do |inscripcion|
			seccion = inscripcion.seccion
			asignatura = seccion.asignatura
			total_creditos += asignatura.creditos
			data << [asignatura.id_uxxi,
				asignatura.descripcion.titleize,
				seccion.numero,
				asignatura.creditos,
				inscripcion.tipo_estado_inscripcion.descripcion]
		end
		
		t = pdf.make_table(data, header: true, row_colors: ["F0F0F0", "FFFFFF"], width: 540, position: :center, cell_style: { inline_format: true, size: 9, align: :center, padding: 3, border_color: '818284'}, :column_widths => {1 => 160})
		t.draw

		pdf.move_down 20

		data = [["<b>Clave</b>", "<b>Créditos</b>", "<b>Estado</b>"]]

		data << ["<i>Número total de créditos matriculados:</i>", total_creditos, ""]

		t = pdf.make_table(data, header: true, row_colors: ["F0F0F0", "FFFFFF"], width: 540, position: :center, cell_style: { inline_format: true, size: 9, align: :center, padding: 3, border_color: '818284'}, :column_widths => {1 => 160})
		t.draw

		pdf.move_down 20

      	pdf.text "Constancia que se expide a solicitud de la parte interesada en la Ciudad Universitaria en Caracas, el día #{I18n.l(Time.new, format: "%d de %B de %Y")}.", size: 10
		pdf.move_down 30
		pdf.text "<b> --Válida para el período actual--</b>", size: 11, inline_format: true, align: :center
		pdf.move_down 50

		pdf.text "Prof. Pedro Coronado", size: 11, align: :center
		pdf.text "Jef(a) de Control de Estudio", size: 11, align: :center

		return pdf
	end

	def self.hacer_kardex id

		pdf = Prawn::Document.new(top_margin: 20)

		estudiante = Estudiante.find id
		# periodos = estudiante.escuela.periodos.order("inicia DESC")
		inscripcionsecciones = estudiante.inscripcionsecciones.joins(:seccion).order("asignatura_id ASC, numero DESC")
		periodo_ids = estudiante.inscripcionsecciones.joins(:seccion).group(:periodo_id).count.keys
		periodos = Periodo.where(id: periodo_ids)

		encabezado_central_con_logo pdf, "Historia Académica"

	# 	#titulo
		pdf.text "<b>Cédula:</b> #{estudiante.usuario_id}", size: 9, inline_format: true
		pdf.text "<b>Plan:</b> #{estudiante.ultimo_plan}", size: 9, inline_format: true
		pdf.text "<b>Alumno:</b> #{estudiante.usuario.apellido_nombre.upcase}", size: 9, inline_format: true
		pdf.move_down 10

		periodos.each do |periodo|
			pdf.move_down 15
			pdf.text "<b>Periodo:</b> #{periodo.id}", size: 10, inline_format: true
			pdf.move_down 5	

			# inscripcionsecciones_periodos = inscripcionsecciones.joins(:seccion).where("secciones.periodo_id": periodo.id).order("secciones.asignatura_id")
			inscripcionsecciones_periodos = inscripcionsecciones.joins(:seccion).where("secciones.periodo_id": periodo.id).sort {|a,b| a.descripcion <=> b.descripcion}
			# inscripcionsecciones_periodos = inscripcionsecciones.del_periodo periodo.id

			if inscripcionsecciones_periodos.count > 0
				data = [["<b>Código</b>", "<b>Asignatura</b>", "<b>Convocatoria</b>", "<b>Créditos</b>", "<b>Final</b>", "<b>Final_alfa</b>", "<b>Sección</b>"]]

				inscripcionsecciones_periodos.each do |h|
					sec = h.seccion
					asig = sec.asignatura
					aux = asig.descripcion
					nota_final = h.calificacion_para_kardex
					data << [asig.id_uxxi, h.descripcion, sec.tipo_convocatoria, asig.creditos, nota_final, h.tipo_calificacion, h.seccion.numero]
				end

			end
			if data
				t = pdf.make_table(data, header: true, row_colors: ["F0F0F0", "FFFFFF"], width: 540, position: :center, cell_style: { inline_format: true, size: 9, align: :center, padding: 3, border_color: '818284'}, :column_widths => {1 => 160})
				t.columns(1..1).position = 'left'
				# t.columns(1..1).width = '100px'
				t.draw
			end

      		t = Time.new
      	end
      	# pdf.start_page_numbering(250, 15, 7, nil, to_utf16("#{t.day} / #{t.month} / #{t.year}       Página: <PAGENUM> de <TOTALPAGENUM>"), 1)

		pdf.move_down 20
		pdf.text "<b>NOTA:</b> CUANDO EXISTA DISCREPANCIA ENTRE LOS DATOS CONTENIDOS EN LAS ACTAS DE EXAMENES Y ÉSTE COMPROBANTE, LOS PRIMEROS SE TENDRÁN COMO AUTÉNTICOS PARA CUALQUIER FIN.", size: 11, inline_format: true, align: :justify
		pdf.move_down 10
		pdf.text "* ÉSTE COMPROBANTE ES DE CARACTER INFORMATIVO, NO TIENE VALIDEZ LEGAL *", font_size: 11, align: :center
		pdf.move_down 15
		pdf.text "________________", size: 11, align: :right
		pdf.move_down 5
		pdf.text "Firma Autorizada", size: 11, align: :right

		return pdf
	end

	private

	def self.encabezado_central_con_logo pdf, titulo

		pdf.image "app/assets/images/logo_ucv.png", position: :center, height: 50, valign: :top
		pdf.move_down 5
		pdf.text "UNIVERSIDAD CENTRAL DE VENEZUELA", align: :center, size: 12
		pdf.move_down 5
		pdf.text "FACULTAD DE HUMANIDADES Y EDUCACIÓN", align: :center, size: 12
		pdf.move_down 5
		pdf.text "CONTROL DE ESTUDIOS DE PREGRADO", align: :center, size: 12
		pdf.move_down 5
		pdf.text titulo, align: :center, size: 12, style: :bold

		pdf.move_down 5

		# return pdf		
	end


end