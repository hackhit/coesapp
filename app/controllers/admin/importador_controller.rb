module Admin
	class ImportadorController < ApplicationController
		before_action :filtro_administrador
		before_action :filtro_autorizado#, only: [:importar_seccion, :importar_profesores, :importar_estudiantes]

		def index
			@titulo = "Importador"
		end

		def seleccionar_archivo
			@titulo = "Importador - Paso1"
		end

		def importar
			total = ImportCsv.importar_de_archivo params[:datafile].tempfile, params[:objeto]
			flash[:success] = "Total de #{params[:objeto].pluralize} agregadas: #{total}"
			redirect_to action: 'seleccionar_archivo'

		end

		# def vista_previa

		# 	@csv = ImportCsv.preview params[:datafile].tempfile
		# 	@csv_file = params[:datafile].tempfile

		# 	@objeto = params[:objeto].camelize.constantize
		# 	# object.camelize.constantize.create(row.to_hash)
		# 	# ImportCsv.import_from_file params[:datafile].tempfile, params[:objeto]
		# end

		# ==== IMPORTADOR DE SECCIONES ===== #
		def seleccionar_archivo_inscripciones
			@titulo = "Importador de Archivos de Inscripciones"
		end
		def importar_inscripciones
			flash[:info] = ImportCsv.importar_inscripciones params[:datafile].tempfile, params[:escuela_id], params[:periodo_id]
			redirect_to action: 'seleccionar_archivo_inscripciones'
		end

		# ==== IMPORTADOR DE PROFESORES ===== #
		def seleccionar_archivo_profesores
			@titulo = "Importador de Archivos de Profesores"
		end

		def importar_profesores
			flash[:info] = ImportCsv.importar_profesores params[:datafile].tempfile
			redirect_to action: 'seleccionar_archivo_profesores'
		end

		# ==== IMPORTADOR DE ESTUDIANTES ===== #
		def seleccionar_archivo_estudiantes
			@escuelas = current_admin ? current_admin.escuelas : Escuela.all
			@titulo = "Importador de Archivos de Estudiantes por Escuela"
		end

		def importar_estudiantes
			flash[:info] = ImportCsv.importar_estudiantes params[:datafile].tempfile, params[:escuela_id], params[:plan_id], params[:periodo_id], params[:grado]
			redirect_to action: 'seleccionar_archivo_estudiantes'
		end

	end
end