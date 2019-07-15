
class ExportarExcel
	include Prawn::View

	def self.to_utf16(valor)
		require 'iconv'
		# Iconv.iconv('ISO-8859-15', 'UTF-8', valor).to_s

		ic_ignore = Iconv.new('ISO-8859-15', 'UTF-8')
		return ic_ignore.iconv(valor).to_s
	end


	def self.estudiantes_x_plan_csv plan_id, periodo_id
		require 'csv'
		
		atributos = ['CEDULA', 'ASIGNATURA', 'DENOMINACION', 'CREDITO', 'NOTA_FINAL', 'NOTA_DEFI', 'TIPO_EXAM', 'PER_LECTI', 'ANO_LECTI', 'SECCION', 'PLAN1']

		csv_data =CSV.generate(headers: true, col_sep: ";") do |csv|

			csv << atributos

			plan = Plan.find plan_id
			plan.estudiantes.each do |es|
				(es.inscripcionsecciones.del_periodo periodo_id).each_with_index do |h,i| # puede cambiar por el periodo_id
					est = h.estudiante
					sec = h.seccion
					asig = sec.asignatura

					nota_def = h.pi? ? 'PI' : h.colocar_nota_final
					nota_final = h.nota_final_para_csv
					nota_def = nota_final if nota_final.eql? 'SN'

					nota_def = nota_final if asig.absoluta?

					csv << [est.usuario_id, asig.id, asig.descripcion, asig.creditos, nota_final, nota_def, 'F', sec.periodo.getPeriodoLectivo, sec.periodo.anno, sec.numero, plan.id]

					if h.calificacion_posterior

						nota_final = nota_def = h.colocar_nota_posterior

						csv << [est.usuario_id, asig.id, asig.descripcion, asig.creditos, nota_final, nota_def, h.tipo_calificacion_id.to_s.last, sec.periodo.getPeriodoLectivo, sec.periodo.anno, sec.numero, plan.id]

					end

				end
			end

		end
		return csv_data
	end


	def self.inscritos_escuela_periodo periodo_id, escuela_id

		require 'spreadsheet'

		@book = Spreadsheet::Workbook.new
		@sheet = @book.create_worksheet :name => "inscritos_#{periodo_id}_#{escuela_id}"

		@sheet.row(0).concat ['	CEDULA', 'NOMBRES', 'APELLIDOS', 'T. CREDITOS', 'CORREO', 'MOVIL', 'LOCAL']

		escuela = Escuela.find escuela_id

		estudiantes = escuela.inscripcionsecciones.del_periodo(periodo_id).estudiantes_inscritos_con_creditos

		estudiantes.each_with_index do |es,i|
			u = Usuario.find es.first
			creditos =  es.last

			@sheet.row(i+1).concat [u.ci, u.nombres, u.apellidos, creditos, u.email, u.telefono_movil, u.telefono_habitacion]
		end


		file_name = "reporte_escuela_periodo.xls"
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
		data = ['Escuela', @seccion.escuela.descripcion.upcase]
		@sheet.row(1).concat data
		# data = ['Plan']
		# @sheet.row(2).concat data
		data = ['Materia', @seccion.asignatura.descripcion]
		@sheet.row(2).concat data
		data = ['Código', @seccion.asignatura.id_uxxi]
		@sheet.row(3).concat data
		data = ['Créditos', @seccion.asignatura.creditos]
		@sheet.row(4).concat data
		data = ['Sección', @seccion.numero]
		@sheet.row(5).concat data
		data = ['Profesor', "#{@seccion.profesor.usuario.nombre_completo if @seccion.profesor}"]
		@sheet.row(6).concat data
		@sheet.row(7).concat ['CI. Profesor', @seccion.profesor_id]
		@sheet.row(8).concat ['Periodo', @seccion.periodo.periodo_del_anno]
		@sheet.row(9).concat ['Año', @seccion.periodo.anno]

		data = ['No.', 'Cédula I', 'Nombres y Apellidos', 'Nota_Def', 'Tipo_Ex.']
		@sheet.row(12).concat data

		@seccion.inscripcionsecciones.sort_by{|h| h.estudiante.usuario.apellidos}.each_with_index do |es,i|
			e = es.estudiante
			@sheet.row(i+13).concat [i+1, e.usuario_id, es.nombre_estudiante_con_retiro, es.colocar_nota, es.tipo_convocatoria]
		end

		file_name = "reporte_secciones.xls"
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

		@sheet.column(0).width = 15 #estudiantes.collect{|e| e.cal_usuario_ci.length if e.cal_usuario_ci}.max+2;
		@sheet.column(1).width = 30	#estudiantes.collect{|e| e.cal_usuario.apellido_nombre.length if e.cal_usuario.apellido_nombre}.max+2;
		@sheet.column(2).width = 30 #estudiantes.collect{|e| e.cal_usuario.correo_electronico.length if e.cal_usuario.correo_electronico}.max+2;
		@sheet.column(3).width = 15

		@sheet.row(0).concat ["Profesor: #{seccion.descripcion_profesor_asignado}"]
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


end