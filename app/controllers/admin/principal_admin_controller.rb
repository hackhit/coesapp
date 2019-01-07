module Admin
	class PrincipalAdminController < ApplicationController

		before_action :filtro_logueado
		before_action :filtro_administrador

		def cambiar_sesion_periodo
			periodo_actual = Periodo.find params[:nuevo].first
			# periodo_anterior = periodo_actual.semestre_anterior

			session[:parametros][:periodo_actual] = periodo_actual.id
			# session[:parametros][:semestre_anterior] = periodo_anterior.id
			redirect_to controller: 'principal_admin'
		end

		def nueva_seccion_admin
			@seccion = Seccion.new
			@seccion.periodo_id = parametros[:periodo_actual]
			@seccion.asignatura_id = params[:id]
		end

		def nueva_seccion_admin_guardar
			@asignatura_id = params[:asignatura][:id]
			@asignatura = Asignatura.find @asignatura_id
			@seccion = @asignatura.secciones.new(params[:seccion])
			if @seccion.save
				flash[:success] = "Seccion agregada con éxito"
			else
				flash[:error] = "No se pudo agregar la nueva sección. Por favor verifique: #{@seccion.errors.full_messages.join(' ')}"
			end
			redirect_to :back, :anchor => 'mat_ALEMI'
		end

		def configuracion_general
			@periodo_actual = ParametroGeneral.periodo_actual
			@periodo_anterior = @periodo_actual.periodo_anterior
			@cal_periodos = Periodo.order("id desc").all
		end


		def set_programaciones
			ParametroGeneral.cambiar_programacion(params[:id])
			respond_to do |format|
				format.html { redirect_back fallback_location: root_path }
				format.json { head :ok }
			end
		end

		def usuarios
			@estudiantes = Estudiante.all.reject{|es| es.usuario.nil?}.sort_by{|es| es.usuario.apellido_nombre}
			@profesores = Profesor.all.reject{|po| po.usuario.nil?}.sort_by{|po| po.usuario.apellido_nombre }
		end

		def set_tab

			session[params[:tipo]] = params[:valor]

			respond_to do |format|
				format.html { redirect_to :back }
				format.json { head :ok }
			end
		end

		def index
			@principal_admin_add_asig = true
			@periodo_actual_id = session[:parametros]['periodo_actual_id']
			@departamentos = Departamento.all
			@usuario = current_usuario
			@admin = current_usuario.administrador

			if @admin
				@editar_asignaturas = true unless @admin.taquilla?
				@departamentos = Departamento.where(id: @admin.departamento_id)if @admin.jefe_departamento?
			end
			
		end
		
		def seleccionar_profesor
			@profesores = Profesor.all.sort_by{|profe| profe.usuario.apellidos}
			@titulo = "Cambio de profesor de sección"
			@seccion = Seccion.find(params[:id])
		end

		def cambiar_profe_seccion 
			@seccion = Seccion.find params[:id]

			@seccion.profesor_id = params[:profesor_id]
			if @seccion.save
				flash[:success] = "Cambio realizado con éxito"
			else
				flash[:error] = "no se pudo guardar los cambios"
			end
			redirect_to :action => 'index'
		end

		def nuevo_profesor
			
		end

		def ver_seccion_admin
			@admin = Administrador.find session[:administrador_id]

			@seccion = Seccion.find params[:id]
			@estudiantes_secciones = @seccion.inscripcionsecciones.sort_by{|es| es.estudiante.usuario.apellidos}
			@titulo = "Sección: #{@seccion.descripcion} - Período: #{@seccion.periodo_id}"
			
			if @seccion.asignatura.catedra_id.eql? 'IB' or @cal_seccion.asignatura.catedra_id.eql? 'LIN' or @cal_seccion.asignatura.catedra_id.eql? 'LE'
				@p1 = 25 
				@p2 =35
				@p3 = 40
			else
				@p1 = @p2 =30
				@p3 = 40
			end
			
		end


		def calificar_admin

			@seccion = Seccion.find params[:id]

			@estudiantes = params[:est]

			@estudiantes.each_pair do |ci,valores|

				@estudiante_seccion = @seccion.inscripcionsecciones.where(estudiante_id: ci).limit(1).first
				
				if valores[:pi]
					tipo_estado_calificacion_id = 'PI'
				else
					if valores[:calificacion_final].to_f >= 10
						tipo_estado_calificacion_id = 'AP'
					else 
						tipo_estado_calificacion_id = 'RE'
					end
				end
				valores[:tipo_estado_calificacion_id] = tipo_estado_calificacion_id
				unless @estudiante_seccion.update_attributes(valores)
					flash[:danger] = "No se pudo guardar la calificación."
					break
				end

			end
			@seccion.calificada = true
			flash[:success] = "Calificaciones guardada satisfactoriamente." if @seccion.save
			redirect_to :action => "index"

		end

		def habilitar_calificar
			if params[:id]
				numero, cal_materia_id, cal_semestre_id = params[:id].to_s.split(",")
				@cal_secciones = CalSeccion.where(numero: numero, cal_materia_id: cal_materia_id, cal_semestre_id: cal_semestre_id).limit(1)
			else
				cal_semestre_actual_id = CalSemestre.find session[:cal_parametros][:semestre_actual]
				@cal_secciones = cal_semestre_actual_id.cal_secciones.calificadas
			end
			total = 0
			error = 0
			@cal_secciones.each do |cal_seccion|
				cal_seccion.calificada = false
				cal_seccion.cal_estudiantes_secciones.each{|es| es.cal_tipo_estado_calificacion_id = 'SC'; es.save}
				if cal_seccion.save
					total += 1
				else
					error += 1
				end
				flash[:info] = "Sin asignaturas por habilitar" if (total == 0)
				flash[:success] = "#{total} asignatura(s) habilitada(s) para calificar" if total > 0  
				flash[:danger] = "#{error} asignatura(s) no pudo(ieron) ser habilitada(s). Favor revise he intentelo nuevamente" if error > 0 
			end

			redirect_to :action => 'index'		
		end


		def reader_pdf
			require 'rubygems'
			require 'pdf-reader'
			require 'open-uri'
			require 'pdf/reader/html'
			cal_semestre_actual_id = session[:parametros]['periodo_actual_id']
			# @reader = PDF::Reader.new('/home/daniel/Descargas/CTT I Alem.pdf')
			# @reader = PDF::Reader.new('/home/daniel/Descargas/Alem I(1).pdf')

			data = params[:archivo][:datafile].tempfile

			@reader = PDF::Reader.new(data)
			# @reader = PDF::Reader.new('/home/daniel/Descargas/Alem IV.pdf')

			@estudiantes_encontrados = []
			@estudiantes_no_encontrados = []		
			@cedulas_no_encontradas = []
			@secciones = []

	 		@reader.pages.each_with_index do |pagina,i|
				if i > 0 # descarto la primera pagina
					# busco la asignatura y seccion
					asignatura = 0
					@nombre_asignatura = ""
					@codigo_asignatura = ""
					@numero_seccion = ""
					estudiantes = false
					caso1 = false
					@numeros_cedulas = []

					pagina.to_s.each_line do |linea|
						if @codigo_asignatura or @nombre_asignatura.blank? or @numero_seccion.blank?

							if asignatura.eql? 2
								@codigo_asignatura = linea.strip
								asignatura =0
							end

							if asignatura.eql? 1
								@nombre_asignatura = linea.strip
								asignatura +=1
							end

							asignatura +=1 if linea.include? "INSCRITOS POR ASIGNATURAS"
							@numero_seccion = (linea.split" ")[1] if (linea.include? "SECCION") or (linea.include? "SECCIÓN")
						end

						if estudiantes
							encontrado = false
							tokens = linea.split(" ")
							tokens.each do |token|

								if token.to_i > 900000
									caso1 = true

									aux_est = CalEstudiante.where(:cal_usuario_ci => token.to_i).limit(1)
									
									if aux_est.count > 0
										@numeros_cedulas << token.to_i
										encontrado = true
									else
										@estudiantes_no_encontrados << "otro"+linea 
										@cedulas_no_encontradas << token.to_i
									end								 
									
								# else
								# 	@estudiantes_no_encontrados << linea #aux_cedula+" "+token.to_i if not encontrado and not aux_cedula.nil?
								end

							end

							if (not caso1) and !tokens.nil? and (tokens.count > 0)
								nombrecedula = tokens.last
								cedula = ""
								nombre = ""
								inter = false
								nombrecedula.each_char do |ca| 
									if ca.to_i > 0 or inter
										cedula += ca.to_s
										inter = true
									else
										nombre += ca.to_s
									end
								end

								if cedula.to_i > 900000
									aux_est = CalEstudiante.where(:cal_usuario_ci => cedula.to_i).limit(1)

									if aux_est.count > 0
										@numeros_cedulas << cedula.to_i
										encontrado = true
									else
										@estudiantes_no_encontrados << "(#{cedula}) "+linea.delete(cedula)
										@cedulas_no_encontradas << cedula.to_i
									end
									caso1 = false

								end

							end

						end
						estudiantes = true if linea.include? "Periodo Academico"

						# @estudiantes_encontrados = CalEstudiante.where(:cal_usuario_ci => @numeros_cedulas) 

					end # pagina.each_line

					@secciones << @numero_seccion

					@cal_materia = CalMateria.where(:id_upsi => @codigo_asignatura).limit(1).first

					@numeros_cedulas.each do |cedula|
						aux = CalEstudiante.where(:cal_usuario_ci => cedula).limit(1)
						if aux.count > 0
							@cal_estudiante_seccion = CalEstudianteSeccion.new
							@cal_estudiante_seccion.cal_estudiante_ci = cedula
							@cal_estudiante_seccion.cal_materia_id = @cal_materia.id if @cal_materia 
							@cal_estudiante_seccion.cal_semestre_id = cal_semestre_actual_id
							@cal_estudiante_seccion.numero = @numero_seccion
							@estudiantes_encontrados << @cal_estudiante_seccion
						else
							@cedulas_no_encontradas << cedula
						end
					end



				end # if pagina > 1

			end # @reader.pages.each

		end # fin reader_pdf

		def importar_secciones_paso2
			@estudiantes_seccion = params[:estudiantes_seccion]
			errores = correctos = 0

			@estudiantes_seccion.each do |es|
				ci,numero,materia,semestre = es.split(" ")
				estudiante_seccion = CalEstudianteSeccion.new

				estudiante_seccion.cal_estudiante_ci = ci
				estudiante_seccion.cal_materia_id = materia
				estudiante_seccion.cal_semestre_id = semestre
				estudiante_seccion.numero = numero
				estudiante_seccion.cal_tipo_estado_calificacion_id = 'SC'
				estudiante_seccion.cal_tipo_estado_inscripcion_id = 'INS'

				if	estudiante_seccion.save
					correctos += 1
				else
					errores += 1
				end
			end

			flash[:info] = "Se incorporaron correctamente #{correctos} estudiantes. / "

			flash[:info] += "Se registraron #{errores} errores al intentar guardar."

			redirect_to :action => "importar_secciones_paso1"		
		end

		def importar_secciones_paso1
			
		end

		def subir_archivo
		# DataFile.save_file(params[:archivo])

		archivo = params[:archivo]

		file_name = archivo['datafile'].original_filename  if  (archivo['datafile'] !='')    

		file = archivo['datafile'].read

		root = "#{Rails.root}/attachments/importados/"

		File.open(root + file_name, "wb")  do |f|  
			flash[:info] += "El Archivo ha sido guardado con éxito." if f.write(file)
		end

		redirect_to :action => "reader_pdf"


		end

	end # fin controller
end