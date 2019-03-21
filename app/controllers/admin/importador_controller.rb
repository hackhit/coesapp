module Admin
	class ImportadorController < ApplicationController
		before_action :filtro_ninja!

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

		def seleccionar_archivo_secciones
			@titulo = "Importador de Archivos de Secciones"
		end

		def seleccionar_archivo_profesores
			@titulo = "Importador de Archivos de Profesores"
		end

		def importar_profesores
			flash[:info] = ImportCsv.importar_profesores params[:datafile].tempfile

			redirect_to action: 'seleccionar_archivo_profesores'
		end

		def importar_seccion
			flash[:info] = ImportCsv.importar_secciones params[:datafile].tempfile, params[:periodo_id]

			redirect_to action: 'seleccionar_archivo_secciones'
		end

	end
end