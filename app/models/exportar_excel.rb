
class ExportarExcel
	include Prawn::View

	def self.to_utf16(valor)
		require 'iconv'
		# Iconv.iconv('ISO-8859-15', 'UTF-8', valor).to_s

		ic_ignore = Iconv.new('ISO-8859-15', 'UTF-8')
		return ic_ignore.iconv(valor).to_s
	end

	def self.estudiantes_csv plan_id, periodo_id, seccion_id = nil, grado = false, escuelas_ids = false
		require 'csv'

		csv_data =CSV.generate(headers: true, col_sep: ";") do |csv|

			csv << %w(CEDULA ASIGNATURA DENOMINACION CREDITO NOTA_FINAL NOTA_DEFI TIPO_EXAM PER_LECTI ANO_LECTI SECCION PLAN1)


			if periodo_id and !grado
				plan = Plan.find plan_id
				plan.estudiantes.each do |es|
					insertar_inscripciones csv, (es.inscripcionsecciones.del_periodo periodo_id), plan
				end
			elsif seccion_id
				seccion = Seccion.find seccion_id
				insertar_inscripciones csv, seccion.inscripciones.aprobado
			else
				if grado.eql? 1
					grados = Grado.tesista
				elsif grado.eql? 2
					grados = Grado.posible_graduando
				elsif grado.eql? 3
					grados = Grado.graduando
				else
					grados = Grado.graduado
				end
				grados.each do |g|
					plan = g.ultimo_plan
					insertar_inscripciones csv, g.estudiante.inscripciones, plan
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

	private

	def self.insertar_inscripciones csv, inscripciones, plan = nil
		inscripciones.each do |insc|
			insertar_inscripcion csv, insc, plan
		end
	end

	def self.insertar_inscripcion csv, inscripcion, plan = nil

		est = inscripcion.estudiante
		sec = inscripcion.seccion
		asig = sec.asignatura

		# ============ Mover a Inscripcionseccion =========== #
		nota_def = inscripcion.pi? ? 'PI' : inscripcion.colocar_nota_final
		nota_final = inscripcion.nota_final_para_csv
		nota_def = nota_final if nota_final.eql? 'SN' or asig.absoluta?
		# ============ Mover a Inscripcionseccion =========== #

		
		plan = inscripcion.ultimo_plan unless plan

		csv << [est.usuario_id, asig.id, asig.descripcion, asig.creditos, nota_final, nota_def, 'F', sec.periodo.getPeriodoLectivo, sec.periodo.anno, sec.numero, plan.id]

		if inscripcion.calificacion_posterior
			nota_final = nota_def = inscripcion.colocar_nota_posterior
			csv << [est.usuario_id, asig.id, asig.descripcion, asig.creditos, nota_final, nota_def, inscripcion.tipo_calificacion_id.to_s.last, sec.periodo.getPeriodoLectivo, sec.periodo.anno, sec.numero, plan.id]
		end
		
	end



end