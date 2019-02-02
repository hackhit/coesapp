
class Archivo
	include Prawn::View

	def self.to_utf16(valor)
		require 'iconv'
		# Iconv.iconv('ISO-8859-15', 'UTF-8', valor).to_s

		ic_ignore = Iconv.new('ISO-8859-15', 'UTF-8')
		return ic_ignore.iconv(valor).to_s

		# c = Iconv.new( 'ISO-8859-15//IGNORE//TRANSLIT', 'utf-8')
		# c.iconv(valor).to_s
		# valor.force_encode("utf-8", invalid: :replace, undef: :replace, replace: '?')
		# valor.force_encoding('ASCII-8BIT', invalid: :replace, undef: :replace, replace: '')
		# valor.force_encoding('ASCII-8BIT')
		# valor.force_encode("utf-8", invalid: :replace, undef: :replace, replace: '?')
		# valor.force_encoding('ASCII-8BIT').force_encoding('UTF-8')
		# valor.valid_encoding?.to_s
		 # Iconv.iconv('iso-8859-15', 'utf-8', valor).to_s
		# Iconv.conv('ISO-8859-15//IGNORE//TRANSLIT', 'UTF-8', valor)

	end

	def self.hacer_constancia_estudio estudiante_ci
		# Variable Locales
		estudiante = Estudiante.find estudiante_ci
		periodo_id = ParametroGeneral.periodo_actual_id
 		inscripciones = estudiante.inscripcionsecciones.del_periodo_actual
		# total_creditos = secciones.joins(:cal_materia).sum("cal_materia.creditos")

		pdf = PDF::Writer.new

		# Parametros
		pdf.margins_cm(1.8)

		# Logos
		pdf.add_image_from_file 'app/assets/images/logo_ucv.jpg', 275, 720, 50,nil

		#texto del encabezado
		pdf.add_text_wrap 50,705,510,to_utf16("UNIVERSIDAD CENTRAL DE VENEZUELA").to_s, 10,:center
		pdf.add_text_wrap 50,690,510,to_utf16("FACULTAD DE HUMANIDADES Y EDUCACIÓN"), 10,:center
		pdf.add_text_wrap 50,675,510,to_utf16("ESCUELA DE IDIOMAS MODERNOS"), 10,:center
		pdf.add_text_wrap 50,660,510,to_utf16("CONTROL DE ESTUDIOS"), 10,:center

		pdf.start_page_numbering(50, 800, 500, nil, "<b><PAGENUM>/<TOTALPAGENUM></b>", 1)
		#titulo
		pdf.add_text_wrap 50,620,510,to_utf16("CONSTANCIA DE ESTUDIO"), 14,:center

		pdf.text "\n"*12

		pdf.text to_utf16 "Quien suscribe, Jefe de Control de Estudios de la Facultad de HUMANIDADES Y EDUCACIÓN, de la Escuela de IDIOMAS MODERNOS de la Universidad Central de Venezuela, por medio de la presente hace constar que el BR. <b>#{estudiante.usuario.apellido_nombre}</b>, titular de la Cédula de Identidad <b>#{estudiante.id}</b> es estudiante regular de esta escuela y esta cursando en el periodo <b>#{periodo_id}</b>; las siguientes asignatura:"

		tabla = PDF::SimpleTable.new
		tabla.heading_font_size = 9
		tabla.font_size = 9
		tabla.show_lines    = :all
		tabla.line_color = Color::RGB::Gray
		tabla.show_headings = true
		tabla.shade_headings = true
		tabla.shade_heading_color = Color::RGB.new(238,238,238)
		tabla.shade_color = Color::RGB.new(230,238,238)
		tabla.shade_color2 = Color::RGB::White
		tabla.shade_rows = :striped
		tabla.orientation   = :center
		tabla.position      = :center

		tabla.columns["codigo"] = PDF::SimpleTable::Column.new("codigo") { |col|
			col.width = 70
			col.heading = to_utf16("<b>Código</b>")
			col.heading.justification = :center
			col.justification = :center
		}
		tabla.columns["asignatura"] = PDF::SimpleTable::Column.new("asignatura") { |col|
			col.width = 250
			col.heading = "<b>Nombre Asignatura</b>"
			col.heading.justification = :left
			col.justification = :left
		}
		tabla.columns["seccion"] = PDF::SimpleTable::Column.new("seccion") { |col|
			col.width = 70
			col.heading = to_utf16("<b>Sección</b>")
			col.heading.justification = :center
			col.justification = :center
		}
		tabla.columns["creditos"] = PDF::SimpleTable::Column.new("creditos") { |col|
			col.width = 25
			col.heading = "<b>UC</b>"
			col.heading.justification = :center
			col.justification = :right
		}
		tabla.columns["estado"] = PDF::SimpleTable::Column.new("estado") { |col|
			col.width = 50
			col.heading = "<b> </b>"
			col.heading.justification = :center
			col.justification = :center
		}		
		data = []
		total_creditos = 0
		tabla.column_order = ["codigo", "asignatura", "seccion", "creditos", "estado"]

		inscripciones.each do |inscripcion|
			seccion = inscripcion.seccion
			asignatura = seccion.asignatura
			total_creditos += asignatura.creditos
			data << {"codigo" => "#{asignatura.id_uxxi}",
				"asignatura" => to_utf16("#{asignatura.descripcion}"),
				"seccion" => "#{seccion.numero}",
				"creditos" => "#{asignatura.creditos}",
				"estado" => "#{inscripcion.tipo_estado_inscripcion.descripcion}"}
		end

		pdf.text "\n"*2

		tabla.data.replace data
		tabla.render_on(pdf)

		tabla = PDF::SimpleTable.new
		tabla.heading_font_size = 9
		tabla.show_lines    = :none
		tabla.show_headings = false
		tabla.orientation   = :center
		tabla.position      = :center
		tabla.shade_color = Color::RGB.new(256,256,256)

		tabla.columns["clave"] = PDF::SimpleTable::Column.new("clave") { |col|
			col.width = 390
			col.justification = :right
		}
		tabla.columns["creditos"] = PDF::SimpleTable::Column.new("creditos") { |col|
			col.width = 25
			col.justification = :right
		}
		tabla.columns["estado"] = PDF::SimpleTable::Column.new("estado") { |col|
			col.width = 50
		}		

		tabla.column_order = ["clave", "creditos", "estado"]
		tabla.data.replace [{"clave" => to_utf16("<i>Número total de créditos matriculados:</i>"), "creditos" =>total_creditos, "estado" => ""} ]
		tabla.render_on(pdf)

		pdf.text "\n"*2
      	pdf.text to_utf16("Constancia que se expide a solicitud de la parte interesada en la Ciudad Universitaria en Caracas, el día #{I18n.l(Time.new, format: "%d de %B de %Y")}."), font_size: 10
      	pdf.text "\n"
		pdf.text to_utf16("<b> --Válida para el período actual--</b>"), font_size: 11, justification: :center
		pdf.text "\n"*5
		pdf.text to_utf16("Prof. Pedro Coronado"), font_size: 11, justification: :center
		pdf.text to_utf16("Jef(a) de Control de Estudio"), font_size: 11, justification: :center

		return pdf
	end

	def self.hacer_constancia_inscripcion estudiante_ci
		# Variable Locales
		estudiante = Estudiante.find estudiante_ci
		periodo_id = ParametroGeneral.periodo_actual_id
 		inscripciones = estudiante.inscripcionsecciones.del_periodo_actual
		# total_creditos = secciones.joins(:cal_materia).sum("cal_materia.creditos")

		pdf = PDF::Writer.new

		# Parametros
		pdf.margins_cm(1.8)

		# Logos
		pdf.add_image_from_file 'app/assets/images/logo_ucv.jpg', 275, 720, 50,nil

		#texto del encabezado
		pdf.add_text_wrap 50,705,510,to_utf16("UNIVERSIDAD CENTRAL DE VENEZUELA"), 10,:center
		pdf.add_text_wrap 50,690,510,to_utf16("FACULTAD DE HUMANIDADES Y EDUCACIÓN"), 10,:center
		pdf.add_text_wrap 50,675,510,to_utf16("ESCUELA DE IDIOMAS MODERNOS"), 10,:center
		pdf.add_text_wrap 50,660,510,to_utf16("CONTROL DE ESTUDIOS"), 10,:center

		pdf.start_page_numbering(50, 800, 500, nil, "<b><PAGENUM>/<TOTALPAGENUM></b>", 1)
		#titulo
		pdf.add_text_wrap 50,620,510,to_utf16("CONSTANCIA DE INSCRIPCIÓN"), 14,:center

		pdf.text "\n"*12

		pdf.text to_utf16 "Quien suscribe, Jefe de Control de Estudios de la Facultad de HUMANIDADES Y EDUCACIÓN, de la Escuela de IDIOMAS MODERNOS de la Universidad Central de Venezuela, por medio de la presente hace constar que el BR. <b>#{estudiante.usuario.apellido_nombre}</b>, titular de la Cédula de Identidad <b>#{estudiante.id}</b> esta inscrito en esta Escuela para el período <b>#{periodo_id}</b>; con las siguientes asignatura:"

		tabla = PDF::SimpleTable.new
		tabla.heading_font_size = 9
		tabla.font_size = 9
		tabla.show_lines    = :all
		tabla.line_color = Color::RGB::Gray
		tabla.show_headings = true
		tabla.shade_headings = true
		tabla.shade_heading_color = Color::RGB.new(238,238,238)
		tabla.shade_color = Color::RGB.new(230,238,238)
		tabla.shade_color2 = Color::RGB::White
		tabla.shade_rows = :striped
		tabla.orientation   = :center
		tabla.position      = :center

		tabla.columns["codigo"] = PDF::SimpleTable::Column.new("codigo") { |col|
			col.width = 70
			col.heading = to_utf16("<b>Código</b>")
			col.heading.justification = :center
			col.justification = :center
		}
		tabla.columns["asignatura"] = PDF::SimpleTable::Column.new("asignatura") { |col|
			col.width = 250
			col.heading = "<b>Nombre Asignatura</b>"
			col.heading.justification = :left
			col.justification = :left
		}
		tabla.columns["seccion"] = PDF::SimpleTable::Column.new("seccion") { |col|
			col.width = 70
			col.heading = to_utf16("<b>Sección</b>")
			col.heading.justification = :center
			col.justification = :center
		}
		tabla.columns["creditos"] = PDF::SimpleTable::Column.new("creditos") { |col|
			col.width = 25
			col.heading = "<b>UC</b>"
			col.heading.justification = :center
			col.justification = :right
		}
		tabla.columns["estado"] = PDF::SimpleTable::Column.new("estado") { |col|
			col.width = 50
			col.heading = "<b> </b>"
			col.heading.justification = :center
			col.justification = :center
		}		
		data = []
		total_creditos = 0
		tabla.column_order = ["codigo", "asignatura", "seccion", "creditos", "estado"]

		inscripciones.each do |inscripcion|
			seccion = inscripcion.seccion
			asignatura = seccion.asignatura
			total_creditos += asignatura.creditos
			data << {"codigo" => "#{asignatura.id_uxxi}",
				"asignatura" => to_utf16("#{asignatura.descripcion}"),
				"seccion" => "#{seccion.numero}",
				"creditos" => "#{asignatura.creditos}",
				"estado" => "#{inscripcion.tipo_estado_inscripcion.descripcion}"}
		end

		pdf.text "\n"*2

		tabla.data.replace data
		tabla.render_on(pdf)

		tabla = PDF::SimpleTable.new
		tabla.heading_font_size = 9
		tabla.show_lines    = :none
		tabla.show_headings = false
		tabla.orientation   = :center
		tabla.position      = :center
		tabla.shade_color = Color::RGB.new(256,256,256)

		tabla.columns["clave"] = PDF::SimpleTable::Column.new("clave") { |col|
			col.width = 390
			col.justification = :right
		}
		tabla.columns["creditos"] = PDF::SimpleTable::Column.new("creditos") { |col|
			col.width = 25
			col.justification = :right
		}
		tabla.columns["estado"] = PDF::SimpleTable::Column.new("estado") { |col|
			col.width = 50
		}		

		tabla.column_order = ["clave", "creditos", "estado"]
		tabla.data.replace [{"clave" => to_utf16("<i>Número total de créditos matriculados:</i>"), "creditos" =>total_creditos, "estado" => ""} ]
		tabla.render_on(pdf)

		pdf.text "\n"*2
      	pdf.text to_utf16("Constancia que se expide a solicitud de la parte interesada en la Ciudad Universitaria en Caracas, el día #{I18n.l(Time.new, format: "%d de %B de %Y")}."), font_size: 10
      	pdf.text "\n"
		pdf.text to_utf16("<b> --Válida para el período actual--</b>"), font_size: 11, justification: :center
		pdf.text "\n"*5
		pdf.text to_utf16("Prof. Pedro Coronado"), font_size: 11, justification: :center
		pdf.text to_utf16("Jef(a) de Control de Estudio"), font_size: 11, justification: :center

		return pdf
	end


	def self.cita_horaria periodo_id

		require 'spreadsheet'

		@book = Spreadsheet::Workbook.new
		@sheet = @book.create_worksheet :name => "cita-hotaria"
		periodo = CalSemestre.find periodo_id

		@sheet.row(0).concat ['CÉDULA', 'NOMBRES', 'PLAN', 'PROMEDIO']

		inscritos = InscripcionEnSeccion.where(tipo_estado_inscripcion_id: 'INS', periodo_id: periodo_id).group(:estudiante_id).average(:calificacion_final)

		inscritos.each_with_index do |ins,i|
			ci = ins[0]
			est = Estudiante.find ci
			nombres = est.usuario.apellido_nombre
			plan = est.ultimo_plan
			prom = (ins[1].to_f).round(2)
			@sheet.row(i+1).concat [ci,nombres,plan,prom]

		end

		file_name = "aux_cita_horaria.xls"
		return file_name if @book.write file_name

	end


	def self.estudiantes_x_plan_csv tipo_plan_id, periodo_id

		atributos = ['CEDULA', 'ASIGNATURA', 'DENOMINACION', 'CREDITO', 'NOTA_FINAL', 'NOTA_DEFI', 'TIPO_EXAM', 'PER_LECTI', 'ANO_LECTI', 'SECCION', 'PLAN1']

		csv_data =CSV.generate(headers: true, col_sep: ";") do |csv|

			csv << atributos

			plan = TipoPlan.find tipo_plan_id
			plan.estudiantes.each do |es|
				(es.inscripcionsecciones.del_periodo periodo_id).each_with_index do |h,i| # puede cambiar por el periodo_id
					est = h.estudiante
					sec = h.seccion
					asign = sec.asignatura
					nota_def = h.pi? ? 'PI' : h.colocar_nota
					nota_final = h.nota_final_para_csv
					nota_def = nota_final if nota_final.eql? 'SN'

					csv << [est.usuario_id, asign.id_uxxi, asign.descripcion, asign.creditos, nota_final, nota_def, sec.r_or_f?, 0, sec.periodo.anno, sec.numero, plan.id]

				end
			end

		end
		return csv_data
	end


	def self.registro_estudiantil_x_plan # periodo_id # Falta pasar el periodo_id

		require 'spreadsheet'

		@book = Spreadsheet::Workbook.new
		@sheet = @book.create_worksheet :name => "registro_estudiantil_x_plan"

		# @sheet.row(0).concat %w{CEDULA ASIGNATURA DENOMINACION CREDITO NOTA_FINAL NOTA_DEFI TIPO_EXAM PER_LECTI ANO_LECTI SECCION PLAN1}
		@sheet.row(0).concat ['	CEDULA', 'ASIGNATURA', 'DENOMINACION', 'CREDITO', 'NOTA_FINAL', 'NOTA_DEFI', 'TIPO_EXAM', 'PER_LECTI', 'ANO_LECTI', 'SECCION', 'PLAN1']

		# Plan.all.each do |plan|
		plan = Plan.first
		plan.cal_estudiantes.each do |es|
			es.inscripcionsecciones.del_periodo_actual.each_with_index do |h,i| # puede cambiar por el periodo_id
				est = h.estudiante
				sec = h.seccion
				asign = sec.asignatura
				nota_def = h.pi? ? 'PI' : h.colocar_nota
				nota_final = h.calificacion_final and h.calificacion_final.to_i < 9 ? 'AP' : h.colocar_nota

				@sheet.row(i+1).concat [est.usuario_ci, asign.id_uxxi, "asign.descripcion", asign.creditos, nota_final, nota_def, sec.r_or_f?, 0, sec.periodo.anno, sec.id, plan.id]
				# @sheet.row(i+1).concat  [est.cal_usuario_ci, "sec.cal_materia.id_uxxi", "sec.cal_materia.descripcion", "sec.creditos", nota_final, nota_def, 'R', 1018, 'A1', 'plan.id']

			end
		end

		file_name = "reporte_estudiantil_x_plan.csv"
		return file_name if @book.write file_name
		
	end


	def self.hacer_acta_excel(seccion_id)
		require 'spreadsheet'

		@seccion = Seccion.find seccion_id
		@book = Spreadsheet::Workbook.new
		@sheet = @book.create_worksheet :name => "Reporte #{seccion_id}"

		@sheet.column(0).width = 12
		# @sheet.column(1).width = 40
		@sheet.column(2).width = 40
		# @sheet.column(3).width = 15

		data = ['Facultad', 'HUMANIDADES Y EDUCACIÓN']
		@sheet.row(0).concat data
		data = ['Escuela', 'IDIOMAS MODERNOS']
		@sheet.row(1).concat data
		data = ['Plan']
		@sheet.row(2).concat data
		data = ['Materia', @seccion.asignatura.descripcion]
		@sheet.row(3).concat data
		data = ['Código', @seccion.asignatura.id_uxxi]
		@sheet.row(4).concat data
		data = ['Créditos', @seccion.asignatura.creditos]
		@sheet.row(5).concat data
		data = ['Sección', @seccion.numero]
		@sheet.row(6).concat data
		data = ['Profesor', "#{@seccion.profesor.usuario.nombre_completo if @seccion.profesor}"]
		@sheet.row(7).concat data
		@sheet.row(8).concat ['CI. Profesor', @seccion.profesor_id]
		@sheet.row(9).concat ['Semestre', '0']
		@sheet.row(10).concat ['Año', @seccion.periodo.anno]

		data = ['No.', 'Cédula I', 'Nombres y Apellidos', 'Nota_Final', 'Nota_Def', 'Tipo_Ex.']
		@sheet.row(13).concat data

		@seccion.inscripcionsecciones.each_with_index do |es,i|
			e = es.estudiante
			@sheet.row(i+14).concat [i+1, e.usuario_id, e.usuario.apellido_nombre, es.tipo_calificacion, es.colocar_nota, @seccion.tipo_convocatoria]
		end

		file_name = "reporte_#{@seccion.id}.xls"
		return file_name if @book.write file_name
	end

	def self.hacer_kardex id

		pdf = Prawn::Document.new(top_margin: 20)

		estudiante = Estudiante.find id
		periodos = Periodo.order("id ASC").all
		inscripcionsecciones = estudiante.inscripcionsecciones.joins(:seccion).order("asignatura_id ASC, numero DESC")

		pdf.image "app/assets/images/logo_ucv.png", position: :center, height: 50, valign: :top
		pdf.move_down 5
		pdf.text "UNIVERSIDAD CENTRAL DE VENEZUELA", align: :center, size: 12
		pdf.move_down 5
		pdf.text "FACULTAD DE HUMANIDADES Y EDUCACIÓN", align: :center, size: 12
		pdf.move_down 5
		pdf.text "CONTROL DE ESTUDIOS DE PREGRADO", align: :center, size: 12
		pdf.move_down 5
		pdf.text "Historia Académica", align: :center, size: 12, style: :bold

		pdf.move_down 5
	# 	#titulo
		pdf.text "<b>Cédula:</b> #{estudiante.usuario_id}", size: 9, inline_format: true
		pdf.text "<b>Plan:</b> #{estudiante.ultimo_plan}", size: 9, inline_format: true
		pdf.text "<b>Alumno:</b> #{estudiante.usuario.apellido_nombre.upcase}", size: 9, inline_format: true
		pdf.move_down 10

		periodos.each do |periodo|
			pdf.text "<b>Periodo:</b> #{periodo.id}", size: 10, inline_format: true
			pdf.move_down 5

			secciones_periodo = inscripcionsecciones.joins(:seccion).where("secciones.periodo_id": periodo.id)
			if secciones_periodo.count > 0
				data = [["<b>Código</b>", "<b>Asignatura</b>", "<b>Convocatoria</b>", "<b>Créditos</b>", "<b>Final</b>", "<b>Final_alfa</b>", "<b>Sección</b>"]]

				secciones_periodo.each do |h|
					sec = h.seccion
					asig = sec.asignatura
					aux = asig.descripcion
					nota_final = h.calificacion_para_kardex
					data << [asig.id_uxxi, h.descripcion, sec.tipo_convocatoria, asig.creditos, nota_final, h.tipo_calificacion, h.seccion.numero]
				end

			end
			t = pdf.make_table(data, header: true, row_colors: ["F0F0F0", "FFFFFF"], width: 540, position: :center, cell_style: { inline_format: true, size: 9, align: :center })
			t.draw

      		t = Time.new

      	# pdf.start_page_numbering(250, 15, 7, nil, to_utf16("#{t.day} / #{t.month} / #{t.year}       Página: <PAGENUM> de <TOTALPAGENUM>"), 1)

		pdf.move_down 20
		pdf.text "<b>NOTA:</b> CUANDO EXISTA DISCREPANCIA ENTRE LOS DATOS CONTENIDOS EN LAS ACTAS DE EXAMENES Y ÉSTE COMPROBANTE, LOS PRIMEROS SE TENDRÁN COMO AUTÉNTICOS PARA CUALQUIER FIN.", size: 11, inline_format: true, align: :justify
		pdf.move_down 10
		pdf.text "* ÉSTE COMPROBANTE ES DE CARACTER INFORMATIVO, NO TIENE VALIDEZ LEGAL *", font_size: 11, align: :center
		pdf.move_down 15
		pdf.text "________________", size: 11, align: :right
		pdf.move_down 5
		pdf.text "Firma Autorizada", size: 11, align: :right

		end

		return pdf
	end

	# def self.hacer_kardex(id)
	# 	# Variable Locales
	# 	require "rubygems"
	# 	require "pdf/writer"
	# 	require "pdf/simpletable"

	# 	estudiante = Estudiante.find id
	# 	periodos = Periodo.order("id ASC").all

	# 	#secciones = Inscripcionseccion.where(estudiante_id: estudiante.usuario_id).order("asignatura_id ASC, numero DESC")

	# 	inscripcionsecciones = estudiante.inscripcionsecciones.joins(:seccion).order("asignatura_id ASC, numero DESC")

	# 	pdf = PDF::Writer.new

	# 	# Parametros
	# 	pdf.margins_cm(1.8)

	# 	# Logos

	# 	# pdf.add_image_from_file "app/assets/images/logo_ucv.png", 275, 720, 50, 1

	# 	#texto del encabezado
	# 	pdf.add_text_wrap 50,705,510, "UNIVERSIDAD CENTRAL DE VENEZUELA", 12,:center
	# 	pdf.add_text_wrap 50,690,510,to_utf16("FACULTAD DE HUMANIDADES Y EDUCACIÓN"), 12,:center
	# 	pdf.add_text_wrap 50,675,510,to_utf16("ESCUELA DE IDIOMAS MODERNOS"), 12,:center
	# 	pdf.add_text_wrap 50,660,510,to_utf16("CONTROL DE ESTUDIOS DE PREGRADO"), 12,:center
	# 	pdf.add_text_wrap 50,645,510,to_utf16("<b>Historia Académica</b>"), 12,:center

	# 	#titulo
	# 	pdf.add_text 50,625,to_utf16("<b>Cédula:</b> #{estudiante.usuario_id}"),9
	# 	pdf.add_text 50,610,to_utf16("<b>Plan:</b> #{estudiante.ultimo_plan}"),9
	# 	pdf.add_text 150,625,to_utf16("<b>Alumno:</b> #{estudiante.usuario.apellido_nombre.upcase}"),9

	# 	pdf.text "\n"*10
	# 	periodos.each do |periodo|
	# 		secciones_periodo = inscripcionsecciones.joins(:seccion).where("secciones.periodo_id": periodo.id)
	# 		if secciones_periodo.count > 0


	# 			tabla = PDF::SimpleTable.new
	# 			tabla.heading_font_size = 9
	# 			tabla.font_size = 9
	# 			tabla.show_lines    = :all
	# 			tabla.line_color = Color::RGB::Gray
	# 			tabla.show_headings = true
	# 			tabla.shade_headings = true
	# 			tabla.shade_heading_color = Color::RGB.new(238,238,238)
	# 			tabla.shade_color = Color::RGB.new(230,238,238)
	# 			tabla.shade_color2 = Color::RGB::White
	# 			tabla.shade_rows = :striped
	# 			tabla.orientation   = :center
	# 			tabla.position      = :center


	# 			tabla.columns["codigo"] = PDF::SimpleTable::Column.new("codigo") { |col|
	# 				col.heading = to_utf16("<b>Código</b>")
	# 				col.heading.justification = :center
	# 				col.justification = :center
	# 			}
	# 			tabla.columns["asignatura"] = PDF::SimpleTable::Column.new("asignatura") { |col|
	# 				col.width = 250
	# 				col.heading = "<b>Nombre Asignatura</b>"
	# 				col.heading.justification = :left
	# 				col.justification = :left
	# 			}
	# 			tabla.columns["convocatoria"] = PDF::SimpleTable::Column.new("convocatoria") { |col|
	# 				col.width = 35
	# 				col.heading = "<b>Conv</b>"
	# 				col.heading.justification = :center
	# 				col.justification = :center
	# 			}
	# 			tabla.columns["creditos"] = PDF::SimpleTable::Column.new("creditos") { |col|
	# 				col.width = 25
	# 				col.heading = "<b>UC</b>"
	# 				col.heading.justification = :center
	# 				col.justification = :center
	# 			}				
	# 			tabla.columns["final"] = PDF::SimpleTable::Column.new("final") { |col|
	# 				col.width = 60
	# 				col.heading = to_utf16("<b>Cal. Num</b>")
	# 				col.heading.justification = :center
	# 				col.justification = :center
	# 			}
	# 			tabla.columns["final_alfa"] = PDF::SimpleTable::Column.new("final_alfa") { |col|
	# 				col.width = 60
	# 				col.heading = to_utf16("<b>Cal. Alf</b>")
	# 				col.heading.justification = :center
	# 				col.justification = :center
	# 			}
	# 			tabla.columns["seccion"] = PDF::SimpleTable::Column.new("seccion") { |col|
	# 				col.heading = to_utf16("<b>Sección</b>")
	# 				col.heading.justification = :center
	# 				col.justification = :center
	# 			}
	# 			data = []
	# 			tabla.column_order = ["codigo", "asignatura", "convocatoria", "creditos", "final", "final_alfa", "seccion"]

	# 			secciones_periodo.each do |h|
	# 				sec = h.seccion
	# 				asig = sec.asignatura
	# 				aux = asig.descripcion
	# 				nota_final = h.calificacion_para_kardex
	# 				data << {"codigo" => "#{asig.id_uxxi}",
	# 					"asignatura" => to_utf16(h.descripcion),
	# 					"convocatoria" => to_utf16("#{sec.tipo_convocatoria}"),
	# 					"creditos" => to_utf16("#{asig.creditos}"),
	# 					"final" => to_utf16("#{nota_final}"),
	# 					"final_alfa" => to_utf16("#{h.tipo_calificacion}"),
	# 					"seccion" => to_utf16("#{h.seccion.numero}")
	# 			 	}

	# 			end
	# 			pdf.text "\n"*2

	# 			pdf.text to_utf16("<b>Periodo:</b> #{periodo.id}"), font_size: 10
	# 			pdf.text "\n"

	# 			tabla.data.replace data
	# 			tabla.render_on(pdf)

	# 		end
	# 	end
 #      	t = Time.new

 #      	pdf.start_page_numbering(250, 15, 7, nil, to_utf16("#{t.day} / #{t.month} / #{t.year}       Página: <PAGENUM> de <TOTALPAGENUM>"), 1)
	# 	pdf.text "\n"
	# 	pdf.text to_utf16("<b>NOTA:</b> CUANDO EXISTA DISCREPANCIA ENTRE LOS DATOS CONTENIDOS EN LAS ACTAS DE EXAMENES Y ÉSTE COMPROBANTE, LOS PRIMEROS SE TENDRÁN COMO AUTÉNTICOS PARA CUALQUIER FIN."), font_size: 11
	# 	pdf.text "\n"
	# 	pdf.text to_utf16("* ÉSTE COMPROBANTE ES DE CARACTER INFORMATIVO, NO TIENE VALIDEZ LEGAL *"), font_size: 11, justification: :center

	# 	pdf.text "\n"
	# 	pdf.text "\n"
	# 	pdf.text to_utf16("________________"), font_size: 11, justification: :right
	# 	pdf.text to_utf16("Firma Autorizada"), font_size: 11, justification: :right

	# 	return pdf

	# end

	def self.listado_excel_asignaturas_estudiantes_periodo(periodo_id, nuevos=nil)
		require 'spreadsheet'

		@book = Spreadsheet::Workbook.new
		@sheet = @book.create_worksheet :name => "ReporteEstudiantesPeriodo#{periodo_id}"

		periodo = Periodo.find periodo_id

		if nuevos
			estudiantes = Estudiante.where(cal_tipo_estado_inscripcion_id: 'NUEVO')
		else
			estudiantes = periodo.estudiantes_en_secciones.uniq #Estudiante.join(:cal_secciones).where('cal_secciones.periodo_id = ?', @semestre_id)
		end
		# secciones = e.cal_estudiantes_secciones.del_semestre @semestre_id

		data = 
		@sheet.row(0).concat %w{# CI NOMBRE ASIG1 ASIG2 ASIG3 ASIG4 ASIG5 ASIG6 ASIG7 ASIG8 ASIG9 ASIG10 ASIG11 ASIG12}

		data = []
		estudiantes.each_with_index do |e,i|
			inscripciones_secciones = e.inscripcionsecciones.del_periodo periodo_id
			aux = [i+1, e.usuario_id, e.usuario.apellido_nombre]

			inscripciones_secciones.each do |ins_seccion|
				sec = ins_seccion.seccion
				aux << "#{sec.descripcion} (#{sec.asignatura.id_uxxi})"
			end
			aux 
			@sheet.row(i+1).concat  aux
			# aux = { "CI" => usuario.ci, "NOMBRES" => usuario.apellido_nombre, "CORREO" => usuario.correo_electronico, "MOVIL" => usuario.telefono_movil}
		end
		if nuevos
			file_name = "reporte_estudiantes_asignaturas_nuevos.xls"
		else
			file_name = "reporte_estudiantes_asignaturas_periodo_#{periodo_id}.xls"
		end
		return file_name if @book.write file_name
	end


	def self.listado_excel(tipo,usuarios)
		require 'spreadsheet'

		@book = Spreadsheet::Workbook.new
		@sheet = @book.create_worksheet :name => "Reporte #{tipo}"

		@sheet.column(0).width = 10
		@sheet.column(1).width = 40
		@sheet.column(2).width = 30
		@sheet.column(3).width = 15

		data = %w{CI NOMBRES CORREO MOVIL}
		@sheet.row(0).concat data

		data = []
		usuarios.each_with_index do |usuario,i|
			# aux = { "CI" => usuario.ci, "NOMBRES" => usuario.apellido_nombre, "CORREO" => usuario.correo_electronico, "MOVIL" => usuario.telefono_movil}
			@sheet.row(i+1).concat  [usuario.ci, usuario.apellido_nombre, usuario.correo_electronico, usuario.telefono_movil]
		end

		file_name = "reporte_#{tipo}.xls"
		return file_name if @book.write file_name
	end

	def self.listado_seccion_excel(seccion_id)
		require 'spreadsheet'

		seccion = Seccion.find seccion_id

		@book = Spreadsheet::Workbook.new
		@sheet = @book.create_worksheet :name => "Seccion #{seccion.id}"

		if seccion.periodo_id.eql? '2016-02A'
			inscripcionsecciones = seccion.inscripcionsecciones.no_retirados.confirmados.sort_by{|i_s| i_s.estudiante.usuario.apellidos}
		else
			inscripcionsecciones = seccion.inscripcionsecciones.no_retirados.sort_by{|i_s| i_s.estudiante.usuario.apellidos}
		end
		# cal_estudiantes_secciones.sort_by{|h| h.cal_estudiante.cal_usuario.apellidos}

		@sheet.column(0).width = 15 #estudiantes.collect{|e| e.cal_usuario_ci.length if e.cal_usuario_ci}.max+2;
		@sheet.column(1).width = 30	#estudiantes.collect{|e| e.cal_usuario.apellido_nombre.length if e.cal_usuario.apellido_nombre}.max+2;
		@sheet.column(2).width = 30 #estudiantes.collect{|e| e.cal_usuario.correo_electronico.length if e.cal_usuario.correo_electronico}.max+2;
		@sheet.column(3).width = 15

		@sheet.row(0).concat ["Profesor: #{seccion.profesor.usuario.apellido_nombre}"]
		@sheet.row(1).concat ["Sección: #{seccion.descripcion}"]
		@sheet.row(2).concat %w{CI NOMBRES CORREO MOVIL}

		data = []
		inscripcionsecciones.each_with_index do |i_s,i|
			usuario = i_s.estudiante.usuario
			@sheet.row(i+3).concat  [usuario.ci, i_s.nombre_estudiante_con_retiro, usuario.email, usuario.telefono_movil]
		end

		file_name = "reporte_seccion.xls"
		return file_name if @book.write file_name
	end


	def self.hacer_acta(seccion_id)

		por_pagina = 35
		pdf = PDF::Writer.new
		seccion = Seccion.find seccion_id
		inscripciones_en_seccion = seccion.inscripcionsecciones.sort_by{|h| h.estudiante.usuario.apellidos}
		pdf.start_page_numbering(400, 665, 9, nil, to_utf16("PÁGINA: <b><PAGENUM>/<TOTALPAGENUM></b>"), 1)
		(inscripciones_en_seccion.each_slice por_pagina).to_a.each_with_index do |ests_sec, j| 
			pdf.start_new_page true if j > 0
			pagina_acta_examen_pdf pdf, ests_sec, j*por_pagina
		end

		return pdf

	end


	private 

	def self.pagina_acta_examen_pdf pdf, inscripcionsecciones, j

		seccion = inscripcionsecciones.first.cal_seccion

		encabezado_acta_pdf pdf, seccion, j

		pdf.text "\n"

		tabla = PDF::SimpleTable.new
		encabezado_tabla_pdf tabla


		data = []

		inscripcionsecciones.each_with_index do |es,i|
			e = es.cal_estudiante
			# plan += e.planes.collect{|c| c.id}.join(" | ") if e.planes
			plan = "#{e.ultimo_plan}"
			data << {"n" => j+i+1,
				"ci" => to_utf16(e.usuario_id),
				"nom" => to_utf16(e.usuario.apellido_nombre),
				"cod" => to_utf16(plan),
				"cal_des" => to_utf16(es.tipo_calificacion),
				"cal_num" => to_utf16("#{es.colocar_nota}"),
				"cal_letras" => to_utf16("#{es.calificacion_en_letras}")
		 	}

		end

		if data.count > 0
			tabla.data.replace data
			tabla.render_on(pdf)
		end

		pie_acta_pdf pdf, seccion

	end

	def self.encabezado_tabla_pdf tabla
		tabla.heading_font_size = 8
		tabla.font_size = 7
		tabla.show_lines    = :all
		tabla.line_color = Color::RGB::Gray
		tabla.show_headings = true
		tabla.shade_headings = true
		tabla.shade_heading_color = Color::RGB.new(238,238,238)
		tabla.shade_color = Color::RGB.new(230,238,238)
		tabla.shade_color2 = Color::RGB::White
		tabla.shade_rows = :striped
		tabla.orientation   = :center
		tabla.position      = :center


		tabla.columns["n"] = PDF::SimpleTable::Column.new("n") { |col|
			col.heading = to_utf16("<b>N°</b>")
			col.heading.justification = :center
			col.justification = :center
		}
		tabla.columns["ci"] = PDF::SimpleTable::Column.new("ci") { |col|
			col.width = 60
			col.heading = "<b>CEDULA DE IDENTIDAD</b>"
			col.heading.justification = :center
			col.justification = :left
		}
		tabla.columns["nom"] = PDF::SimpleTable::Column.new("nom") { |col|
			col.heading = "<b>APELLIDOS Y NOMBRES</b>"
			col.heading.justification = :center
			col.justification = :left
		}
		tabla.columns["cod"] = PDF::SimpleTable::Column.new("cod") { |col|
			col.width = 50
			col.heading = "<b>COD PLAN</b>"
			col.heading.justification = :center
			col.justification = :center
		}
		tabla.columns["cal_des"] = PDF::SimpleTable::Column.new("cal_des") { |col|
			col.width = 50
			col.heading = "<b>CALIF. DESCRIP</b>"
			col.heading.justification = :center
			col.justification = :center
		}		
		tabla.columns["cal_num"] = PDF::SimpleTable::Column.new("cal_num") { |col|
			col.width = 50
			col.heading = to_utf16("<b>CALIF. NUMER.</b>")
			col.heading.justification = :center
			col.justification = :center
		}
		tabla.columns["cal_letras"] = PDF::SimpleTable::Column.new("cal_letras") { |col|
			col.heading = to_utf16("<b>CALIF. EN LETRAS</b>")
			col.heading.justification = :center
			col.justification = :center
		}
		tabla.column_order = ["n", "ci", "nom", "cod", "cal_des", "cal_num", "cal_letras"]
		
	end

	def self.encabezado_acta_pdf pdf, seccion, j

		pdf.margins_cm(1.8)

		# Logos
		pdf.add_image_from_file 'app/assets/images/logo_ucv.jpg', 275, 730, 40,nil

		#texto del encabezado
		pdf.add_text_wrap 50,710,510,to_utf16("UNIVERSIDAD CENTRAL DE VENEZUELA"), 12,:center
		pdf.add_text_wrap 50,695,510,to_utf16("PLANILLA DE EXÁMENES"), 12,:center
		pdf.add_text_wrap 50,680,510,to_utf16("TIPO DE EXAMEN: FINAL ANUAL (SEPTIEMBRE)"), 12,:center

		#titulo

		pdf.add_text 50,665,to_utf16("FECHA DE LA EMISIÓN: <b>#{Time.now.strftime('%d/%m/%Y %I:%M %p')}</b>"),9
		pdf.add_text 50,650,to_utf16("EJERCICIO: <b>#{seccion.ejercicio}</b>"),9
		pdf.add_text 50,635,to_utf16("FACULTAD: <b>HUMANIDADES Y EDUCACIÓN</b>"),9
		pdf.add_text 50,620,to_utf16("ESCUELA: <b>IDIOMAS</b>"),9

		pdf.add_text 400,650,to_utf16("ACTA N°: <b>#{seccion.acta_no.upcase}</b>"),9
		pdf.add_text 400,635,to_utf16("PERIODO ACADÉMICO: <b>#{seccion.periodo.anno}</b>"),9
		pdf.add_text 400,620,to_utf16("TIPO CONVOCATORIA: <b>#{seccion.tipo_convocatoria}</b>"),9

		pdf.text "\n"*11
		pdf.text "\n"*3 if j > 0

		tabla = PDF::SimpleTable.new
		tabla.heading_font_size = 9
		tabla.font_size = 9
		tabla.show_lines    = :all
		tabla.show_headings = true
		tabla.orientation   = :center
		tabla.position      = :center

		tabla.column_order = ["asignatura", "codigo", "creditos", "curso", "seccion", "duracion"]

		tabla.columns["asignatura"] = PDF::SimpleTable::Column.new("asignatura") { |col|
			col.heading = to_utf16("<b>ASIGNATURA</b>")
			col.heading.justification = :center
			col.justification = :center
		}
		tabla.columns["codigo"] = PDF::SimpleTable::Column.new("codigo") { |col|
			col.heading = "<b>COD. ASIGNATURA</b>"
			col.heading.justification = :center
			col.justification = :center
		}
		tabla.columns["creditos"] = PDF::SimpleTable::Column.new("creditos") { |col|
			col.heading = "<b>UNID/CRED</b>"
			col.heading.justification = :center
			col.justification = :center
		}				
		tabla.columns["curso"] = PDF::SimpleTable::Column.new("curso") { |col|
			col.heading = to_utf16("<b>CURSO</b>")
			col.heading.justification = :center
			col.justification = :center
		}
		tabla.columns["seccion"] = PDF::SimpleTable::Column.new("seccion") { |col|
			col.heading = to_utf16("<b>SECCIÓN</b>")
			col.heading.justification = :center
			col.justification = :center
		}
		tabla.columns["duracion"] = PDF::SimpleTable::Column.new("duracion") { |col|
			col.heading = to_utf16("<b>DURACIÓN</b>")
			col.heading.justification = :center
			col.justification = :center
		}


		data = []
		asign = seccion.asignatura
		data << {"asignatura" => to_utf16("#{asign.descripcion}"),
			"codigo" => to_utf16("#{asign.id_uxxi}"),
			"creditos" => to_utf16("#{asign.creditos}"),
			"curso" => 1,
			"seccion" => to_utf16("#{seccion.numero}"),
			"duracion" => "0"
	 	}

		tabla.data.replace data
		tabla.render_on(pdf)

	end

	def self.pie_acta_pdf pdf, seccion

		pdf.add_text 150,90,"<b>JURADO EXAMINADOR</b>",9
		pdf.add_text 50,75,"APELLIDOS Y NOMBRES",9
		pdf.add_text 300,75,"FIRMAS",9
		pdf.add_text 250,60,"___________________________",9
		pdf.add_text 250,45,"___________________________",9
		pdf.add_text 250,30,"___________________________",9
		pdf.add_text 50,60,to_utf16("#{seccion.profesor.usuario.apellido_nombre.upcase if seccion.profesor }"),9
		pdf.add_text 50,45,"_______________________________",9
		pdf.add_text 50,30,"_______________________________",9

		pdf.add_text 470,90, to_utf16("<b>SECRETARÍA</b>"),9
		pdf.add_text 410,60,"NOMBRE: _______________________",9
		pdf.add_text 410,45,"FIRMA:     _______________________",9
		pdf.add_text 410,30,"FECHA:    _______________________",9

	end
end