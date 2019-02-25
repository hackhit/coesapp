module Admin

	class DescargarController < ApplicationController
		before_action :filtro_logueado
		before_action :filtro_admin_profe, only: [:listado_seccion, :notas_seccion]
		before_action :filtro_estudiante, only: [:programaciones, :cita_horaria]
		before_action :filtro_administrador, except: [:programaciones, :cita_horaria, :kardex, :constancia_inscripcion, :constancia_estudio, :listado_seccion, :notas_seccion]

		# PDFs
		def listado_seccion
			pdf = ExportarPdf.listado_seccion params[:id]
			seccion = Seccion.find params[:id]
			unless send_data pdf.render,:filename => "listado_#{seccion.asignatura_id}_#{seccion.numero}.pdf",:type => "application/pdf", :disposition => "attachment"
			flash[:mensaje] = "en estos momentos no se pueden descargar las notas, intentelo luego."
			end
			
		end

		def notas_seccion
			pdf = ExportarPdf.notas_seccion params[:id]
			unless send_data pdf.render,:filename => "notas_#{seccion.asignatura_id}_#{seccion.numero}.pdf",:type => "application/pdf", :disposition => "attachment"
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

		def constancia_inscripcion
			pdf = ExportarPdf.hacer_constancia_inscripcion params[:id], current_periodo.id, params[:escuela_id]
			unless send_data pdf.render,:filename => "constancia_inscripcion_#{params[:id].to_s}.pdf",:type => "application/pdf", :disposition => "attachment"
				flash[:error] = "En estos momentos no se pueden descargar el acta, intentelo más tarde."
			end
			return
			
		end

		def constancia_estudio
			pdf = ExportarPdf.hacer_constancia_estudio params[:id], current_periodo.id, params[:escuela_id]
			unless send_data pdf.render,:filename => "constancia_estudio_#{params[:id].to_s}.pdf",:type => "application/pdf", :disposition => "attachment"
				flash[:error] = "En estos momentos no se pueden descargar el acta, intentelo más tarde."
			end
			return
			
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