
class ExportarPdf
	include Prawn::View


	def self.listado_seccion seccion, profesor = false
  		asig = seccion.asignatura
		# Variable Locales
		pdf = Prawn::Document.new(top_margin: 20)

		#titulo
		encabezado_central_con_logo pdf, "Coordinación Académica"

		tabla_descripcion_seccion pdf, seccion

		pdf.move_down 10

		if profesor and seccion.profesores.ids.include? profesor.id 
			pdf.text "Profesor Secundario: #{profesor.descripcion_usuario}", size: 10
		else
			pdf.text "Profesor: #{seccion.descripcion_profesor_asignado}", size: 10
		end
	 
		pdf.move_down 10

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


	def self.acta_seccion seccion_id
		seccion = Seccion.find seccion_id

		# Variable Locales
		pdf = Prawn::Document.new(top_margin: 275, bottom_margin: 100)


		inscripciones = seccion.inscripcionsecciones.sort_by{|h| h.estudiante.usuario.apellidos}
		
		pdf.repeat(:all, dynamic: true) do
			pdf.bounding_box([0, 660], :width => 540, :height => 265) do
				self.encabezado_central_con_logo pdf, "PLANILLA DE EXÁMENES"
				self.tabla_descripcion_convocatoria pdf, seccion
				self.tabla_descripcion_seccion pdf, seccion
 				pdf.transparent(0) { pdf.stroke_bounds }
			end
			pdf.bounding_box([0, -10], :width => 540, :height => 90) do
				self.acta_firmas pdf, seccion
 				pdf.transparent(0) { pdf.stroke_bounds }
			end
		end
		self.insertar_tabla_convocados pdf, inscripciones
		pdf.number_pages "PÁGINA: <b> <page> / <total> </b>", {at: [pdf.bounds.right - 230, 524], size: 9, inline_format: true}
		return pdf
	end


	def self.hacer_constancia_estudio estudiante_ci, periodo_id, escuela_id
		# Variable Locales
		estudiante = Estudiante.find estudiante_ci
		usuario = estudiante.usuario
		escuela = Escuela.find escuela_id

		# inscripciones = estudiante.inscripcionsecciones.del_periodo periodo_id

		# inscripciones = estudiante.inscripcionsecciones.del_periodo(periodo_id).includes(:escuela).where("escuelas.id = ?", escuela_id).references(:escuelas)

		inscripciones = estudiante.inscripcionsecciones.del_periodo(periodo_id).de_la_escuela(escuela.id)
		
		total = inscripciones.count 
		# total_creditos = secciones.joins(:cal_materia).sum("cal_materia.creditos")

		pdf = Prawn::Document.new(top_margin: 20)

		#titulo
		encabezado_central_con_logo pdf, "CONSTANCIA DE ESTUDIO", escuela

		pdf.move_down 5

		# pdf.start_page_numbering(50, 800, 500, nil, "<b><PAGENUM>/<TOTALPAGENUM></b>", 1)

		pdf.text "Quien suscribe, Jefe de Control de Estudios de la Facultad de HUMANIDADES Y EDUCACIÓN, de la Universidad Central de Venezuela, por medio de la presente hace constar que #{usuario.la_el} BR. <b>#{estudiante.usuario.apellido_nombre}</b>, titular de la Cédula de Identidad <b>#{estudiante.id}</b> es estudiante regular de la Escuela de <b>#{escuela.descripcion.titleize}</b> y está cursando en el periodo <b>#{periodo_id}</b> #{'la'.pluralize(total)} #{'siguiente'.pluralize(total)} #{'asignatura'.pluralize(total)}:", size: 10, inline_format: true, align: :justify

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



	def self.hacer_constancia_preinscripcion estudiante_id, escuela_id

		grado = Grado.where(escuela_id: escuela_id, estudiante_id: estudiante_id).first

		pdf = Prawn::Document.new(top_margin: 20)
		insertar_contenido_constancia_preinscripcion pdf, grado
		pdf.move_down 10

		data = [["------------ COPIA DEL ESTUDIANTE ------------"]]
		t = pdf.make_table(data, header: false, width: 540, position: :center, cell_style: { inline_format: true, size: 9, align: :center, padding: 1, border_color: 'FFFFFF'})
		t.draw
		pdf.move_down 20
		pdf.text "---------------------------------------------------------------------------------------------------------------------------------------", size: 12, inline_format: true, align: :justify
		pdf.move_down 20

		insertar_contenido_constancia_preinscripcion pdf, grado
		pdf.move_down 10
		data = [["------------ COPIA DEL ADMINISTRACIÓN ------------"]]
		t = pdf.make_table(data, header: false, width: 270, position: :center, cell_style: { inline_format: true, size: 9, align: :center, padding: 1, border_color: 'FFFFFF'})
		t.draw
		pdf.move_down 20
		pdf.text "---------------------------------------------------------------------------------------------------------------------------------------", size: 12, inline_format: true, align: :justify
		pdf.move_down 10

		data = [["<b>#{grado.estudiante.usuario.apellido_nombre} - #{grado.estudiante_id} - #{grado.escuela.descripcion}</b>"]]

		t = pdf.make_table(data, header: false, width: 500, position: :center, cell_style: { inline_format: true, size: 9, align: :center, padding: 1, border_color: 'FFFFFF'})
		t.draw

		return pdf
	end

	def self.hacer_constancia_inscripcion_sin_horario estudiante_ci, periodo_id, escuela_id
		# Variable Locales
		estudiante = Estudiante.find estudiante_ci
		usuario = estudiante.usuario

		escuela = Escuela.find escuela_id

		# inscripciones = estudiante.inscripcionsecciones.del_periodo periodo_id

		# VERSIÓN ORIGINAL FUNCIONAL
		# inscripciones = estudiante.inscripcionsecciones.del_periodo(periodo_id).includes(:escuela).where("escuelas.id = ?", escuela_id).references(:escuelas)

		inscripciones = estudiante.inscripcionsecciones.del_periodo(periodo_id).de_la_escuela(escuela.id)

		# total_creditos = secciones.joins(:cal_materia).sum("cal_materia.creditos")

		pdf = Prawn::Document.new(top_margin: 20)

		#titulo
		encabezado_central_con_logo pdf, "CONSTANCIA DE INSCRIPCIÓN", escuela

		pdf.move_down 5

		# pdf.start_page_numbering(50, 800, 500, nil, "<b><PAGENUM>/<TOTALPAGENUM></b>", 1)

		pdf.text "Quien suscribe, Jefe de Control de Estudios de la Facultad de HUMANIDADES Y EDUCACIÓN, de la Universidad Central de Venezuela, por medio de la presente hace constar que #{usuario.la_el} BR. <b>#{estudiante.usuario.apellido_nombre}</b>, titular de la Cédula de Identidad <b>#{estudiante.id}</b> está inscrit#{usuario.genero} en la Escuela de <b>#{escuela.descripcion.upcase}</b> para el período <b>#{periodo_id}</b> con las siguientes asignaturas:", size: 10, inline_format: true, align: :justify

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
		

		t = pdf.make_table(data, header: true, row_colors: ["F0F0F0", "FFFFFF"], width: 400, position: :center, cell_style: { inline_format: true, size: 9, align: :center, padding: 3, border_color: '818284'}, :column_widths => {1 => 160})
		t.draw
		
		pdf.move_down 20

		data = [["<b>Clave</b>", "<b>Créditos</b>", "<b>Estado</b>"]]

		data << ["<i>Número total de créditos matriculados:</i>", total_creditos, ""]

		u = pdf.make_table(data, header: true, row_colors: ["F0F0F0", "FFFFFF"], width: 540, position: :center, cell_style: { inline_format: true, size: 9, align: :center, padding: 3, border_color: '818284'}, :column_widths => {1 => 160})
		
		u.draw
		# pdf.table([[t,u]], width: 540)
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
		usuario = estudiante.usuario

		escuela = Escuela.find escuela_id

		grado = Grado.find [estudiante_ci,escuela_id] #estudiante.grados.where(escuela_id: escuela.id).first

		# inscripciones = estudiante.inscripcionsecciones.del_periodo(periodo_id).de_la_escuela(escuela.id)
		inscripciones = grado.inscripciones.del_periodo(periodo_id)

		pdf = Prawn::Document.new(top_margin: 20)

		contenido_inscripcion_horario pdf, estudiante, usuario, escuela, grado, inscripciones, periodo_id
		
		pdf.start_new_page
		
		contenido_inscripcion_horario pdf, estudiante, usuario, escuela, grado, inscripciones, periodo_id

		return pdf
	end

	def self.paintHorario secciones_ids, pdf
		bloques = Bloquehorario.where(horario_id: secciones_ids)
		
		v = pdf.make_table(printHorarioVacio(pdf), header: true, width: 200, cell_style: {inline_format: true, size: 9, overflow: :expand }, column_widths: {0 => 35}) do
			cells.border_width = 0.5
			cells.border_color = "faf7f7"
			# cells.overflow = "expand"
			cells.padding = 2
			cells.style(overflow: :visible)
			row(0).height = 20

			row(0).border_top_color = "000000"
			row(1).border_top_color = "000000"
			row(-1).border_bottom_color = "000000"
			row([5,9,13,17,21, 25, 29, 33, 37, 41, 45, 49]).border_top_color = "9c9b98"
			column([0,1]).border_left_color = "000000"
			column([2,3,4,5]).border_left_color = "9c9b98"
			column(-1).border_right_color = "000000"

			bloques.each do |bh|
				dia_index = Bloquehorario.dias[bh.dia]+1
				horaEntrada, minutoEntrada = bh.entrada_to_schedule.split(":")
				horaSalida, minutoSalida = bh.salida_to_schedule.split(":")
				
				inicio = (horaEntrada.to_i*4)+(minutoEntrada.to_i/15)+1
				final = (horaSalida.to_i*4)+(minutoSalida.to_i/15)

				rows(inicio..final).columns(dia_index).background_color = bh.horario.color_rgb_to_hex 2
				# rows([inicio,final]).columns(dia_index).border_width = 1

				rows(inicio..final).columns(dia_index).border_left_color = bh.horario.color_rgb_to_hex
				rows(inicio..final).columns(dia_index).border_left_width = 1.7
				rows(inicio..final).columns(dia_index).border_right_width = 1.7
				rows(inicio..final).columns(dia_index).border_right_color = bh.horario.color_rgb_to_hex
				rows(inicio).columns(dia_index).border_top_color = bh.horario.color_rgb_to_hex
				rows(inicio).columns(dia_index).border_top_width = 1.7
				rows(final).columns(dia_index).border_bottom_color = bh.horario.color_rgb_to_hex
				rows(final).columns(dia_index).border_bottom_width = 1.7
				# rows(inicio..final).columns(dia_index).content = "x"

				# columns(dia_index).rowspan = 3
				rows(final).columns(dia_index).size = 7
				rows(final).columns(dia_index).height = 10
				rows(final).columns(dia_index).rotate = 90
				tope = bh.horario.seccion.asignatura_id.length
				rows(final).columns(dia_index).content = "#{bh.horario.seccion.asignatura_id[tope-4..tope]}"

				# v.rows(inicio).columns(dia_index).borders = [:top]
				# v.rows(inicio).columns(dia_index).border_widths = [0,1,1,0]
			end
		end
		return v

	end

	def self.printHorarioVacio pdf

		data = %w(Lunes Martes Miércoles Jueves Viernes)
		data.unshift("")
		data.map!{|a| "<b>"+a[0..2]+"</b>"}
		data = [data]

		for i in 7..19 do
			aux = i < 12 ? "#{i} am" : "#{i - 12} pm"
			aux = "12 m" if i.eql? 12
			data << [{:content => "<b>#{aux}</b>", :rowspan => 4} ,"","","","",""] # En blanco
			data << [""]*5
			data << [""]*5
			data << [""]*5

		end
		data
	end

	def self.hacer_kardex id, escuela_id, alfabetico=false

		pdf = Prawn::Document.new(top_margin: 20)

		grado = Grado.find [id,escuela_id]
		estudiante = grado.estudiante #Estudiante.find id
		# periodos = estudiante.escuela.periodos.order("inicia DESC")
		escuela = grado.escuela #Escuela.find escuela_id

		inscripciones = grado.inscripciones#estudiante.inscripcionsecciones.joins(:escuela).where("escuelas.id = :e or pci_escuela_id = :e", e: escuela_id)

		periodo_ids = inscripciones.joins(:seccion).group("secciones.periodo_id").count.keys
		periodos = Periodo.where(id: periodo_ids)

		encabezado_central_con_logo pdf, "Historia Académica", escuela
		#titulo
		pdf.text "<b>Fecha de Emisión:</b> #{I18n.l(Time.now, format: '%a, %d / %B / %Y (%I:%M%p)')}", size: 9, inline_format: true
		pdf.text "<b>Cédula:</b> #{estudiante.usuario_id}", size: 9, inline_format: true
		# hplan = grado.ultimo_plan #estudiante.ultimo_plan_de_escuela(escuela_id)
		# hplan = grado.ultimo_plan ? grado.ultimo_plan.descripcion_completa : "--"
		pdf.text "<b>Plan:</b> #{grado.plan_descripcion}", size: 9, inline_format: true
		pdf.text "<b>Alumno:</b> #{estudiante.usuario.apellido_nombre.upcase}", size: 9, inline_format: true

		periodos.each do |periodo|
			pdf.move_down 15
			pdf.text "<b>Periodo:</b> #{periodo.id}", size: 10, inline_format: true
			pdf.move_down 5	

			# inscripciones_del_periodo = inscripcionsecciones.joins(:seccion).where("secciones.periodo_id": periodo.id).order("secciones.asignatura_id")
			if alfabetico
				inscripciones_del_periodo = inscripciones.joins(:seccion).where("secciones.periodo_id": periodo.id).sort {|a,b| a.descripcion(periodo.id) <=> b.descripcion(periodo.id)}
			else
				inscripciones_del_periodo = inscripciones.joins(:seccion).where("secciones.periodo_id": periodo.id).sort {|a,b| a.asignatura.id <=> b.asignatura.id}
			end
			# inscripciones_del_periodo = inscripcionsecciones.del_periodo periodo.id

			if inscripciones_del_periodo.count > 0
				data = [["<b>Código</b>", "<b>Asignatura</b>", "<b>Créditos</b>", "<b>Sección</b>", "<b>Convocatoria</b>", "<b>Calif. Num.</b>", "<b>Calif. alfa</b>"]]

				inscripciones_del_periodo.each do |h|

					sec = h.seccion
					asig = sec.asignatura
					nota = h.valor_calificacion(false, 'F')
					data << [asig.id_uxxi, h.descripcion_asignatura_pdf, asig.creditos, h.seccion.numero, h.tipo_convocatoria('F'), nota, h.tipo_calificacion_to_cod]

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

		pdf.move_down 10

		resumen pdf, inscripciones
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

	def self.contenido_inscripcion_horario pdf, estudiante, usuario, escuela, grado, inscripciones, periodo_id
		total = inscripciones.count

		#titulo
		encabezado_central_con_logo pdf, "CONSTANCIA DE INSCRIPCIÓN Y HORARIO", escuela

		pdf.move_down 5

		pdf.text "Quien suscribe, Jefe de Control de Estudios de la Facultad de HUMANIDADES Y EDUCACIÓN, de la Universidad Central de Venezuela, por medio de la presente hace constar que #{usuario.la_el} BR. <b>#{estudiante.usuario.apellido_nombre}</b>, titular de la Cédula de Identidad <b>#{estudiante.id}</b> está inscrit#{usuario.genero} en la Escuela de <b>#{escuela.descripcion.upcase}</b> para el período <b>#{periodo_id}</b> con #{'la'.pluralize(total)} #{'siguiente'.pluralize(total)} #{'asignatura'.pluralize(total)} y en el siguiente horario:", size: 10, inline_format: true, align: :justify

		# pdf.move_down 10

		data = [["", "<b>Código</b>", "<b>Asignatura</b>", "<b>Sec</b>", "<b>Créd</b>", "<b>Estado</b>"]]

		total_creditos = 0

		inscripciones.each do |inscripcion|
			seccion = inscripcion.seccion
			asignatura = seccion.asignatura
			total_creditos += asignatura.creditos
			data << ["", asignatura.id_uxxi,
				asignatura.descripcion_pci(seccion.periodo_id).upcase,
				seccion.numero,
				asignatura.creditos,
				inscripcion.estado_inscripcion]
		end

		data << [{:content => "<b>Número Total de Créditos Matriculados: </b>", :colspan => 4} ,total_creditos,""]

		t = pdf.make_table(data, header: true, row_colors: ["F0F0F0", "FFFFFF"], width: 300, position: :center, cell_style: { inline_format: true, size: 9, align: :center, padding: 3, border_color: '818284'}, :column_widths => {0 => 5, 2 => 120})

		inscripciones.each_with_index do |inscripcion, i|
			t.rows(i+1).columns(0).background_color = inscripcion.seccion.horario.color_rgb_to_hex if inscripcion.seccion and inscripcion.seccion.horario
		end
		# t.row(0).width = 3
		# t.row(-1).width = 30

		secciones_ids = grado.secciones.where(periodo_id: periodo_id).ids 
		bloques = Bloquehorario.where(horario_id: secciones_ids)
		v = paintHorario secciones_ids, pdf

		pdf.move_down 10
		pdf.table([[t,v]], width: 560, cell_style: {border_width: 0})

		data = [["<b>Clave</b>", "<b>Créditos</b>", "<b>Estado</b>"]]
		data << ["<i>Número total de créditos matriculados:</i>", total_creditos, ""]

		# u = pdf.make_table(data, header: true, row_colors: ["F0F0F0", "FFFFFF"], width: 320, position: :left, cell_style: { inline_format: true, size: 9, align: :center, padding: 3, border_color: '818284'}, :column_widths => {1 => 60})
		
		# u.draw

		pdf.move_down 10

		pdf.text "Constancia que se expide a solicitud de la parte interesada en la Ciudad Universitaria en Caracas, el día #{I18n.l(Time.new, format: "%d de %B de %Y")}.", size: 10
		pdf.move_down 10
		pdf.text "<b> --Válida para el período actual--</b>", size: 11, inline_format: true, align: :center
		pdf.move_down 40

		pdf.text "Prof. Pedro Coronado", size: 11, align: :center
		pdf.text "Jef(a) de Control de Estudio", size: 11, align: :center

		
	end

	def self.insertar_contenido_constancia_preinscripcion pdf, grado
		estudiante = grado.estudiante
		usuario = estudiante.usuario
		escuela = grado.escuela
		
		encabezado_central_con_logo pdf, "CONSTANCIA DE PREINSCRIPCIÓN", nil, 8

		# Opcion 1:
		pdf.image "app/assets/images/foto-perfil.png", at: [430, 395], height: 100

		pdf.move_down 20

		pdf.text "El departamento de Control de Estudios de la Facultad de HUMANIDADES Y EDUCACIÓN, por medio de la presente hace constar que #{usuario.la_el} BR. <b>#{estudiante.usuario.apellido_nombre}</b>, titular de la Cédula de Identidad <b>#{estudiante.id}</b> está <b>preinscrit#{usuario.genero}</b> en la Escuela de <b>#{escuela.descripcion.upcase}</b> de la Universidad Central de Venezuela.", size: 10, inline_format: true, align: :justify

		pdf.move_down 5

		pdf.text "El estudiante debe consignar esta planilla ante el Dpto de Control de Estudios para su firma y sello en una carpeta marrón tamaño oficio con sus respectivos ganchos.", size: 10, inline_format: true, align: :justify
		pdf.move_down 10
		pdf.text "<b>Fecha de Emisión:</b> #{I18n.l(Date.today, format: '%A, %d de %B de %Y')}.", size: 10, inline_format: true
		
		pdf.move_down 60

		pdf.text "Nombre y Firma del funcionario receptor                                                                  Firma del Estudiante", size: 10, align: :center

	end



	def self.resumen pdf, inscripcion

		cursados = inscripcion.total_creditos_cursados
		aprobados = inscripcion.total_creditos_aprobados
		eficiencia = (cursados and cursados > 0) ? (aprobados.to_f/cursados.to_f).round(4) : 0.0

		aux = inscripcion.cursadas
		promedio_simple = (aux and aux.count > 0 and aux.average('calificacion_final')) ? aux.average('calificacion_final').round(4) : 0.0

		aux = inscripcion.aprobadas
		promedio_simple_aprob = (aux and aux.count > 0 and aux.average('calificacion_final')) ? aux.average('calificacion_final').round(4) : 0.0

		aux = inscripcion.ponderado_aprobadas
		ponderado_apro = aprobados > 0 ? (aux.to_f/aprobados.to_f).round(4) : 0.0

		aux = inscripcion.ponderado
		ponderado = cursados > 0 ? (aux.to_f/cursados.to_f).round(4) : 0.0

		pdf.text "<b>Resumen Académico:</b>", size: 10, inline_format: true

		data = [["<b>Créditos Inscritos:</b>", inscripcion.total_creditos], 
				["<b>Créditos Cursados:</b>", cursados], 
				["<b>Créditos Aprobados (Sin Equivalencias):</b>", inscripcion.sin_equivalencias.total_creditos_aprobados],
				["<b>Créditos Equivalencia:</b>", inscripcion.por_equivalencia.total_creditos],
				["<b>Total Créditos Aprobados:</b>", aprobados],
				["<b>Eficiencia:</b>", eficiencia],
				["<b>Promedio Simple:</b>", promedio_simple],
				["<b>Promedio Simple Aprobado:</b>", promedio_simple_aprob],
				["<b>Promedio Ponderado Aprobado:</b>", ponderado_apro],
				["<b>Promedio Ponderado:</b>", ponderado]
			]

		t = pdf.make_table(data, header: true, row_colors: ["F0F0F0", "FFFFFF"], width: 300, cell_style: { inline_format: true, size: 9, padding: 3, border_color: '818284'})
		t.columns(1..1).position = 'right'
		t.draw


	end


	def self.insertar_tabla_convocados pdf, inscripciones#, k

		data = [["<b>N°</b>", "<b>CÉDULA DE IDENTIDAD</b>", "<b>APELLIDOS Y NOMBRES</b>", "<b>COD. PLAN</b>", "<b>CALIF. DESCR.</b>", "<b>TIPO</b>","<b>CALIF. NUM.</b>", "<b>CALIF. EN LETRAS</b>"]]
		i = 1
		inscripciones.each do |h|
			if h.tiene_calificacion_posterior?
				estado_a_letras = 'AP'
				tipo_calificacion_id = 'NF'
				cali_a_letras = (h.calificacion_en_letras 'final')
			else
				tipo_calificacion_id = h.tipo_calificacion_id
				estado_a_letras = h.estado_a_letras
				cali_a_letras = h.calificacion_en_letras
			end

			data << [i, 
			h.estudiante_id,
			h.estudiante.usuario.apellido_nombre,
			h.grado.plan_id,
			estado_a_letras,
			tipo_calificacion_id,
			h.colocar_nota_final,
			cali_a_letras
			]

			if h.tiene_calificacion_posterior?
				i += 1
				data << [i, 
				h.estudiante_id,
				h.estudiante.usuario.apellido_nombre,
				h.grado.plan_id,
				h.estado_a_letras,
				h.tipo_calificacion_id,
				h.colocar_nota_posterior,
				h.calificacion_en_letras
				]
			end
			i += 1
		end

		pdf.table data do |t|
			t.width = 540
			t.position = :center
			t.header = true
			t.row_colors = ["F0F0F0", "FFFFFF"]
			t.column_widths = {1 => 60, 2 => 220, 5 => 30, 7 => 70}
			t.cell_style = {:inline_format => true, :size => 9, :padding => 2, align: :center, padding: 3, border_color: '818284' }
			t.column(2).style(:align => :justify)
			t.row(0).style(:align => :center)
			# t.column(1).style(:font_style => :bold)
		end

	end


	def self.tabla_descripcion_convocatoria pdf, seccion
		# pdf.number_pages "<page> in a total of <total>", [bounds.right - 50, 0]
    # pdf.start_page_numbering(, 9, nil, , 1)

		data = [["FECHA DE LA EMISIÓN: <b>#{Time.now.strftime('%d/%m/%Y %I:%M %p')}</b>", ""]]
		data << ["EJERCICIO: <b>#{seccion.ejercicio}</b>", "ACTA No.: <b>#{seccion.acta_no.upcase}</b>" ]
		data << ["ESCUELA: <b>#{seccion.escuela.descripcion.upcase}</b>", "PERÍODO ACADÉMICO: <b>#{seccion.periodo.anno}</b>" ]

		t = pdf.make_table(data, header: false, width: 540, position: :center, cell_style: { inline_format: true, size: 9, align: :left, padding: 1, border_color: 'FFFFFF'})
		t.draw
	end


	def self.acta_firmas pdf, seccion

		data = [["<b>JURADO EXAMINADOR</b>", "<b>SECRETARÍA</b>"]]
		t = pdf.make_table(data, header: false, width: 540, position: :center, cell_style: { inline_format: true, size: 9, align: :center, padding: 1, border_color: 'FFFFFF'}, :column_widths => {0 => 360})
		t.draw

		pdf.move_down 5

		prof_aux = seccion.profesor ? seccion.profesor.usuario.apellido_nombre.upcase : "___________________________" 
		data = [["APELLIDOS Y NOMBRES", "FIRMAS", ""]]
		data << ["#{prof_aux}", "___________________________", "NOMBRE: _______________________"]
		data << ["___________________________", "___________________________", "FIRMA:     _______________________"]
		data << ["___________________________", "___________________________", "FECHA:    _______________________"]

		t = pdf.make_table(data, header: false, width: 540, position: :center, cell_style: { inline_format: true, size: 9, align: :center, padding: 1, border_color: 'FFFFFF'})
		t.draw

	end


	def self.tabla_descripcion_seccion pdf, seccion
		pdf.move_down 10

		asig = seccion.asignatura

		data = [["<b>Código</b>", "<b>Asignatura</b>", "<b>Sección</b>", "<b>Período</b>", "<b>Créditos</b>"]]

		data << [ "#{asig.id}", "#{asig.descripcion}", "#{seccion.numero}", "#{seccion.periodo_id}", "#{asig.creditos}"]

		t = pdf.make_table(data, header: true, row_colors: ["F0F0F0", "FFFFFF"], width: 540, position: :center, cell_style: { inline_format: true, size: 10, align: :center, padding: 3, border_color: '818284'}, column_widths: {1 => 300})
		t.draw
		pdf.move_down 10		
	end

	def self.encabezado_central_con_logo pdf, titulo, escuela = nil, size = nil

		size_logo = size ? size*4 : 50 
		size ||= 12
		pdf.image "app/assets/images/logo_ucv.png", position: :center, height: size_logo, valign: :top
		pdf.move_down 5
		pdf.text "UNIVERSIDAD CENTRAL DE VENEZUELA", align: :center, size: size 
		pdf.move_down 5
		pdf.text "FACULTAD DE HUMANIDADES Y EDUCACIÓN", align: :center, size: size
		pdf.move_down 5
		pdf.text "CONTROL DE ESTUDIOS DE PREGRADO", align: :center, size: size
		if escuela
			pdf.move_down 5
			pdf.text escuela.descripcion.upcase, align: :center, size: size
		end

		pdf.move_down 5
		pdf.text titulo, align: :center, size: size, style: :bold

		pdf.move_down 5

		# return pdf
	end


end