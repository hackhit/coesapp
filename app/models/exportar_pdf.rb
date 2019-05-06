
class ExportarPdf
	include Prawn::View


  def self.listado_seccion seccion_id
  		seccion = Seccion.find seccion_id
  		asig = seccion.asignatura
		# Variable Locales
		pdf = Prawn::Document.new(top_margin: 20)

		#titulo
		encabezado_central_con_logo pdf, "Coordinación Académica"

		tabla_descripcion_seccion pdf, seccion

		inscripciones = seccion.inscripcionsecciones.sort_by{|h| h.estudiante.usuario.apellidos}

		data = [["<b>#</b>", "<b>Cédula</b>", "<b>Nombre</b>"]]

		inscripciones.each_with_index do |h,i|
			data << [i+1, 
			h.estudiante_id,
			h.estudiante.usuario.apellido_nombre]
		end
		
		t = pdf.make_table(data, header: true, row_colors: ["F0F0F0", "FFFFFF"], width: 540, position: :center, cell_style: { inline_format: true, size: 9, align: :justify, padding: 3, border_color: '818284'}, :column_widths => {1 => 250})
		t.draw

		return pdf
	end

  def self.notas_seccion seccion_id
  		seccion = Seccion.find seccion_id

		# Variable Locales
		pdf = Prawn::Document.new(top_margin: 20)

		#titulo
		encabezado_central_con_logo pdf, "Coordinación Académica"
		
		tabla_descripcion_seccion pdf, seccion

		if seccion.periodo_id.eql? '2016-02A'
		  inscripciones = seccion.inscripcionsecciones.confirmados.sort_by{|h| h.estudiante.usuario.apellidos}
		else
		  inscripciones = seccion.inscripcionsecciones.sort_by{|h| h.estudiante.usuario.apellidos}
		end

		if seccion.asignatura.numerica3?
			data = [["<b>#</b>", "<b>Nombre</b>", "<b>Cédula</b>", "<b>1era. Calif</b>", "<b>2da. Calif</b>", "<b>3era. Calif</b>", "<b>Calif Final</b>", "<b>Estado</b>"]]
		else
			data = [["<b>#</b>", "<b>Nombre</b>", "<b>Cédula</b>", "<b>Final</b>", "<b>Estado</b>"]]
		end

		inscripciones.each_with_index do |h,i|
			if seccion.asignatura.numerica3?
				data << [i+1, h.estudiante.usuario.apellido_nombre,
				h.estudiante_id,
				h.primera_calificacion.to_s,
				h.segunda_calificacion.to_s,
				h.tercera_calificacion.to_s,
				h.valor_calificacion,
				h.estado.titleize
				]
			else
				data << [i+1, 
				h.estudiante.usuario.apellido_nombre,
				h.estudiante_id,
				h.valor_calificacion,
				h.estado.titleize
				]			
			end
		end
		
		t = pdf.make_table(data, header: true, row_colors: ["F0F0F0", "FFFFFF"], width: 540, position: :center, cell_style: { inline_format: true, size: 9, align: :justify, padding: 3, border_color: '818284'}, :column_widths => {1 => 250})
		t.draw


		# pdf.text "#{Time.now.strftime('%d/%m/%Y %I:%M%p')} - Página: 1 de 1"
		return pdf
	end


	def self.hacer_constancia_estudio estudiante_ci, periodo_id, escuela_id
		# Variable Locales
		estudiante = Estudiante.find estudiante_ci

		escuela = Escuela.find escuela_id

		# inscripciones = estudiante.inscripcionsecciones.del_periodo periodo_id

		inscripciones = estudiante.inscripcionsecciones.del_periodo(periodo_id).includes(:escuela).where("escuelas.id = ?", escuela_id).references(:escuelas)
		
		# total_creditos = secciones.joins(:cal_materia).sum("cal_materia.creditos")

		pdf = Prawn::Document.new(top_margin: 20)

		#titulo
		encabezado_central_con_logo pdf, "CONSTANCIA DE ESTUDIO", escuela

		pdf.move_down 5

		# pdf.start_page_numbering(50, 800, 500, nil, "<b><PAGENUM>/<TOTALPAGENUM></b>", 1)

		pdf.text "Quien suscribe, Jefe de Control de Estudios de la Facultad de HUMANIDADES Y EDUCACIÓN, de la Escuela de #{escuela.descripcion.upcase} de la Universidad Central de Venezuela, por medio de la presente hace constar que el BR. <b>#{estudiante.usuario.apellido_nombre}</b>, titular de la Cédula de Identidad <b>#{estudiante.id}</b> es estudiante regular de esta escuela (#{escuela.descripcion.titleize}) y esta cursando en el periodo <b>#{periodo_id}</b>; las siguientes asignatura:", size: 10, inline_format: true, align: :justify

		pdf.move_down 20

		data = [["<b>Código</b>", "<b>Asignatura</b>", "<b>Sección</b>", "<b>Créditos</b>", "<b>Estado</b>"]]

		total_creditos = 0

		inscripciones.each do |inscripcion|
			seccion = inscripcion.seccion
			asignatura = seccion.asignatura
			total_creditos += asignatura.creditos
			data << [asignatura.id_uxxi,
				asignatura.descripcion_pci(seccion.periodo_id).upcase,
				seccion.numero,
				asignatura.creditos,
				inscripcion.estado_inscripcion]
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

	def self.hacer_constancia_inscripcion estudiante_ci, periodo_id, escuela_id
		# Variable Locales
		estudiante = Estudiante.find estudiante_ci

		escuela = Escuela.find escuela_id

		# inscripciones = estudiante.inscripcionsecciones.del_periodo periodo_id

		inscripciones = estudiante.inscripcionsecciones.del_periodo(periodo_id).includes(:escuela).where("escuelas.id = ?", escuela_id).references(:escuelas)
		# total_creditos = secciones.joins(:cal_materia).sum("cal_materia.creditos")

		pdf = Prawn::Document.new(top_margin: 20)

		#titulo
		encabezado_central_con_logo pdf, "CONSTANCIA DE INSCRIPCIÓN", escuela

		pdf.move_down 5

		# pdf.start_page_numbering(50, 800, 500, nil, "<b><PAGENUM>/<TOTALPAGENUM></b>", 1)

		pdf.text "Quien suscribe, Jefe de Control de Estudios de la Facultad de HUMANIDADES Y EDUCACIÓN, de la Escuela de <b>#{escuela.descripcion.upcase}</b> de la Universidad Central de Venezuela, por medio de la presente hace constar que el BR. <b>#{estudiante.usuario.apellido_nombre}</b>, titular de la Cédula de Identidad <b>#{estudiante.id}</b> esta inscrito en esta Escuela (#{escuela.descripcion.titleize}) para el período <b>#{periodo_id}</b>; con las siguientes asignatura:", size: 10, inline_format: true, align: :justify

		pdf.move_down 20

		data = [["<b>Código</b>", "<b>Asignatura</b>", "<b>Sección</b>", "<b>Créditos</b>", "<b>Estado</b>"]]

		total_creditos = 0

		inscripciones.each do |inscripcion|
			seccion = inscripcion.seccion
			asignatura = seccion.asignatura
			total_creditos += asignatura.creditos
			data << [asignatura.id_uxxi,
				asignatura.descripcion_pci(seccion.periodo_id).upcase,
				seccion.numero,
				asignatura.creditos,
				inscripcion.estado_inscripcion]
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

	def self.hacer_kardex id, escuela_id

		pdf = Prawn::Document.new(top_margin: 20)

		estudiante = Estudiante.find id
		# periodos = estudiante.escuela.periodos.order("inicia DESC")
		escuela = Escuela.find escuela_id
		inscripcionsecciones = estudiante.inscripcionsecciones.includes(:escuela).where("escuelas.id = ?", escuela_id).references(:escuelas)

		periodo_ids = inscripcionsecciones.joins(:seccion).group("secciones.periodo_id").count.keys
		periodos = Periodo.where(id: periodo_ids)

		encabezado_central_con_logo pdf, "Historia Académica", escuela
		#titulo
		pdf.text "<b>Cédula:</b> #{estudiante.usuario_id}", size: 9, inline_format: true
		pdf.text "<b>Plan:</b> #{estudiante.ultimo_plan}", size: 9, inline_format: true
		pdf.text "<b>Alumno:</b> #{estudiante.usuario.apellido_nombre.upcase}", size: 9, inline_format: true
		pdf.move_down 10

		periodos.each do |periodo|
			pdf.move_down 15
			pdf.text "<b>Periodo:</b> #{periodo.id}", size: 10, inline_format: true
			pdf.move_down 5	

			# inscripcionsecciones_periodos = inscripcionsecciones.joins(:seccion).where("secciones.periodo_id": periodo.id).order("secciones.asignatura_id")
			inscripcionsecciones_periodos = inscripcionsecciones.joins(:seccion).where("secciones.periodo_id": periodo.id).sort {|a,b| a.descripcion(periodo.id) <=> b.descripcion(periodo.id)}
			# inscripcionsecciones_periodos = inscripcionsecciones.del_periodo periodo.id

			if inscripcionsecciones_periodos.count > 0
				data = [["<b>Código</b>", "<b>Asignatura</b>", "<b>Créditos</b>", "<b>Sección</b>", "<b>Convocatoria</b>", "<b>Calif. Num.</b>", "<b>Calif. alfa</b>"]]

				inscripcionsecciones_periodos.each do |h|

					sec = h.seccion
					asig = sec.asignatura
					nota = h.valor_calificacion(false, 'F')
					data << [asig.id_uxxi, h.descripcion(sec.periodo_id), asig.creditos, h.seccion.numero, h.tipo_convocatoria('F'), nota, h.tipo_calificacion_to_cod]

					if h.tiene_calificacion_posterior?
						nota = h.valor_calificacion(false, 'P')
						data << [asig.id_uxxi, h.descripcion(sec.periodo_id), asig.creditos, h.seccion.numero, h.tipo_convocatoria('R'), nota, h.tipo_calificacion_to_cod]
					end
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


	# def self.hacer_acta(seccion_id)
	# 	por_pagina = 35

	# 	pdf = Prawn::Document.new(top_margin: 15)

	# 	seccion = Seccion.find seccion_id
	# 	estudiantes_seccion = seccion.cal_estudiantes_secciones.sort_by{|h| h.cal_estudiante.cal_usuario.apellidos}
	# 	pdf.start_page_numbering(400, 665, 9, nil, to_utf16("PÁGINA: <b><PAGENUM>/<TOTALPAGENUM></b>"), 1)
	# 	(estudiantes_seccion.each_slice por_pagina).to_a.each_with_index do |ests_sec, j| 
	# 		pdf.start_new_page true if j > 0
	# 		pagina_acta_examen_pdf pdf, ests_sec, j*por_pagina
	# 	end

	# 	return pdf

	# end



	private

	def self.tabla_descripcion_seccion pdf, seccion
		pdf.move_down 10

		asig = seccion.asignatura

		data = [["<b>Código</b>", "<b>Asignatura</b>", "<b>Sección</b>", "<b>Período</b>", "<b>Créditos</b>"]]

		data << [ "#{asig.id}", "#{asig.descripcion}", "#{seccion.numero}", "#{seccion.periodo_id}", "#{asig.creditos}"]

		t = pdf.make_table(data, header: true, row_colors: ["F0F0F0", "FFFFFF"], width: 540, position: :center, cell_style: { inline_format: true, size: 10, align: :center, padding: 3, border_color: '818284'})
		t.draw

		pdf.move_down 10

		#instructor
		pdf.text "Profesor: #{seccion.descripcion_profesor_asignado}", size: 10
	 
		pdf.move_down 10

	end

	def self.encabezado_central_con_logo pdf, titulo, escuela = nil

		pdf.image "app/assets/images/logo_ucv.png", position: :center, height: 50, valign: :top
		pdf.move_down 5
		pdf.text "UNIVERSIDAD CENTRAL DE VENEZUELA", align: :center, size: 12
		pdf.move_down 5
		pdf.text "FACULTAD DE HUMANIDADES Y EDUCACIÓN", align: :center, size: 12
		pdf.move_down 5
		pdf.text "CONTROL DE ESTUDIOS DE PREGRADO", align: :center, size: 12
		if escuela
			pdf.move_down 5
			pdf.text escuela.descripcion.upcase, align: :center, size: 12
		end

		pdf.move_down 5
		pdf.text titulo, align: :center, size: 12, style: :bold

		pdf.move_down 5

		# return pdf
	end


end