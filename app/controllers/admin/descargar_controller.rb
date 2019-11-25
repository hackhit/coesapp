module Admin

	class DescargarController < ApplicationController
		before_action :filtro_logueado
		before_action :filtro_admin_profe, only: [:listado_seccion, :notas_seccion, :listado_seccion_excel]
		before_action :filtro_estudiante, only: [:programaciones, :cita_horaria]
		before_action :filtro_administrador, except: [:programaciones, :cita_horaria, :kardex, :constancia_inscripcion, :constancia_preinscripcion, :constancia_estudio, :listado_seccion, :notas_seccion, :listado_seccion_excel]

		def listado_completo_estudiante
			# file = ExportarExcel.listado_estudiantes current_periodo.id, params[:estado]
			# send_data file, filename: "listado_completo_#{params[:estado]}_#{current_periodo.id}.xls"

			if !(params[:escuela].blank?) && escuela = Escuela.find_by(descripcion: params[:escuela])
				@escuela_id = escuela.id
			end

			if !(params[:plan].blank?) && plan = Plan.find(params[:plan])
				@plan_id = plan.id
			end
			p @escuela_id

			file = ExportarExcel.listado_estudiantes current_periodo.id, params[:estado], @escuela_id, @plan_id, params[:ingreso]
			# send_file file, type: "application/vnd.ms-excel", x_sendfile: true, stream: false, filename: "listado_completo_#{params[:estado]}_#{current_periodo.id}.xls", disposition: "attachment"

			File.open(file, 'r') do |f|
				send_data f.read, type: "text/excel", filename: "listado_completo_#{params[:estado]}_#{current_periodo.id}.xls"
			end

			File.delete(file) if File.exist?(file)
		end

		def exportar_lista_csv
			if params[:periodo_id]
				data = ExportarExcel.estudiantes_csv params[:id], params[:periodo_id]
				send_data data, filename: "estudiantes_x_plan_#{params[:periodo_id]}_#{params[:id]}.csv"
			elsif params[:seccion_id]
				data = ExportarExcel.estudiantes_csv nil, nil, params[:seccion_id]
				send_data data, filename: "estudiantes_x_seccion_#{params[:seccion_id]}.csv"
			elsif params[:grado]
				escuelas_ids = current_admin.escuelas.ids
				data = ExportarExcel.estudiantes_csv nil, nil, nil, params[:grado], escuelas_ids
				send_data data, filename: "grado_#{params[:grado]}.csv"
			end
		end

		# PDFs
		def listado_seccion
			seccion = Seccion.find params[:id]

			pdf = ExportarPdf.listado_seccion seccion, current_profesor
			unless send_data pdf.render, filename: "listado_#{seccion.asignatura_id}_#{seccion.numero}.pdf", type: "application/pdf", disposition: "attachment"
			flash[:mensaje] = "en estos momentos no se pueden descargar las notas, intentelo luego."
			end
			
		end

		def notas_seccion_online
			seccion = Seccion.find params[:id]
			pdf = ExportarPdf.acta_seccion params[:id]

			respond_to do |format|
				format.pdf do
					send_data pdf.render,
					filename: "export.pdf",
					type: 'application/pdf',
					disposition: 'inline'
				end
			end
		end

		def notas_seccion
			seccion = Seccion.find params[:id]
			pdf = ExportarPdf.acta_seccion params[:id]
			info_bitacora "Descarga de acta pdf seccion##{seccion.id}", Bitacora::DESCARGA

			unless send_data pdf.render, filename: "ACTA_#{seccion.acta_no}.pdf", type: "application/pdf", disposition: :attachment # disposition: 'inline' # para renderizar en linea  
				flash[:mensaje] = "en estos momentos no se pueden descargar las notas, intentelo luego."
			end
		end

		def kardex
			info_bitacora 'Descarga de kardex', Bitacora::DESCARGA
			pdf = ExportarPdf.hacer_kardex params[:id], params[:escuela_id]
			unless send_data pdf.render, filename: "kardex_#{params[:id]}.pdf", type: "application/pdf", disposition: "attachment"
				flash[:error] = "En estos momentos no se pueden descargar el kardex, intentelo luego."
			end
			
		end

		def constancia_preinscripcion
			info_bitacora 'Descarga de constancia de Preinscripción', Bitacora::DESCARGA
			pdf = ExportarPdf.hacer_constancia_preinscripcion params[:id], params[:escuela_id]
			unless send_data pdf.render, filename: "constancia_inscripcion_#{params[:id].to_s}.pdf", type: "application/pdf", disposition: "attachment"
				flash[:error] = "En estos momentos no se pueden descargar el acta, intentelo más tarde."
			end
			return
			
		end



		def constancia_inscripcion

			if current_estudiante
				periodo_id = current_estudiante.ultimo_periodo_inscrito_en params[:escuela_id]
			else
				periodo_id = current_periodo.id
			end
			if periodo_id.nil?
				flash[:error] = "Usted no posse inscripciones en la escuela solicidata"
				redirect_back fallback_location: root_path
			else
				pdf = ExportarPdf.hacer_constancia_inscripcion params[:id], periodo_id, params[:escuela_id]

				# unless send_data pdf.render, filename: "constancia_inscripcion_#{params[:id].to_s}.pdf", type: "application/pdf", disposition: "attachment"
				# 	flash[:error] = "En estos momentos no se pueden descargar el acta, intentelo más tarde."
				# end

			end
			respond_to do |format|
				format.pdf do
					send_data pdf.render,
					filename: "export.pdf",
					type: 'application/pdf',
					disposition: 'inline'
				end
			end
			
		end

		def constancia_estudio

			if current_estudiante
				periodo_id = current_estudiante.ultimo_periodo_inscrito_en params[:escuela_id]
			else
				periodo_id = current_periodo.id
			end

			if periodo_id.nil?
				flash[:error] = "Usted no posse inscripciones en la escuela solicidata"
				redirect_back fallback_location: root_path
			else
				pdf = ExportarPdf.hacer_constancia_estudio params[:id], periodo_id, params[:escuela_id]
				unless send_data pdf.render, filename: "constancia_estudio_#{params[:id].to_s}.pdf", type: "application/pdf", disposition: "attachment"
					flash[:error] = "En estos momentos no se pueden descargar el acta, intentelo más tarde."
				end
				return
			end
			
		end

		# EXCELs
		def inscritos_escuela_periodo

			file_name = ExportarExcel.inscritos_escuela_periodo params[:id], params[:escuela_id]
			send_file file_name, type: "application/vnd.ms-excel", x_sendfile: true, stream: false, filename: "reporte_#{params[:id]}_#{params[:escuela_id]}.xls", disposition: "attachment"
		end

		def listado_seccion_excel
			seccion_id = params[:id]
			file_name = ExportarExcel.listado_seccion_excel(seccion_id)
			send_file file_name, type: "application/vnd.ms-excel", x_sendfile: true, stream: false, filename: "listado_seccion_#{seccion_id}.xls", disposition: "attachment"
		end


		def acta_examen_excel
			excel = ExportarExcel.hacer_acta_excel params[:id]
			unless send_file excel, type: "application/vnd.ms-excel", x_sendfile: true, stream: false, filename: "acta_excel_seccion_#{params[:id].to_s}.xls", disposition: "attachment"
				flash[:mensaje] = "En estos momentos no se pueden descargar el acta, intentelo más tarde."
			end
			
		end

	end
end