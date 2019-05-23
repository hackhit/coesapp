module Admin
	class InscripcionseccionesController < ApplicationController
		before_action :filtro_logueado
		before_action :filtro_administrador#, only: [:destroy]
		# before_action :filtro_admin_mas_altos!, except: [:destroy]
		# before_action :filtro_ninja!, only: [:destroy]

		def cambiar_calificacion

			inscripcion = Inscripcionseccion.find params[:inscripcionseccion_id]

			if inscripcion.asignatura.numerica3? and params[:parciales]
				inscripcion.primera_calificacion = params[:parciales][0]
				inscripcion.segunda_calificacion = params[:parciales][1]
				inscripcion.tercera_calificacion = params[:parciales][2]
			end

			params[:tipo_calificacion_id] = 'NF' if params[:tipo_calificacion_id].nil?
			if (params[:tipo_calificacion_id].eql? TipoCalificacion::DIFERIDO) or (params[:tipo_calificacion_id].eql? TipoCalificacion::REPARACION)
				calificacion_anterior = inscripcion.calificacion_posterior
				inscripcion.calificacion_posterior = params[:calificacion_posterior] ? params[:calificacion_posterior].to_i : params[:calificacion].to_i

			elsif params[:tipo_calificacion_id].eql? TipoCalificacion::PI
				calificacion_anterior = inscripcion.calificacion_final
				inscripcion.calificacion_final = 0 
				params[:calificacion] = 0
				inscripcion.calificacion_posterior = nil 
			else
				calificacion_anterior = inscripcion.calificacion_final
				inscripcion.calificacion_final = params[:calificacion].to_i
				inscripcion.calificacion_posterior = nil
			end

			if inscripcion.calificacion_final.to_i.eql? 0 or inscripcion.calificacion_final.nil?

				inscripcion.primera_calificacion = inscripcion.calificacion_final
				inscripcion.segunda_calificacion = inscripcion.calificacion_final
				inscripcion.tercera_calificacion = inscripcion.calificacion_final

			end

			inscripcion.tipo_calificacion_id = params[:tipo_calificacion_id]
			inscripcion.estado = inscripcion.estado_segun_calificacion
			if inscripcion.seccion.asignatura.absoluta?
				inscripcion.estado = Inscripcionseccion.estados.key params[:calificacion].to_i
				inscripcion.calificacion_posterior = nil
				inscripcion.calificacion_final = nil
			end

			respond_to do |format|

				format.html {
					if inscripcion.save

						info_bitacora "Se cambió la calificación del estudiante #{inscripcion.estudiante.usuario.descripcion} de la sección #{inscripcion.seccion.descripcion}. Calificacion anterior: #{calificacion_anterior}" , Bitacora::ESPECIAL, inscripcion, params[:comentario]
						flash[:success] = 'Calificación modificada con éxito'

					else
						flash[:danger] = 'Error al intentar modificar la calificación. Por favor verifica e inténtalo nuevamente.'
					end
					redirect_to inscripcion.seccion
				}

				format.json {
					inscripcion.save
				}


			end

		end
		
		def buscar_estudiante
			# if params[:id]
			# 	@inscripciones = Inscripcionseccion.joins(:seccion).where(estudiante_id: params[:id], "secciones.periodo_id" => current_periodo.id)
			# 	if @inscripciones.count > 2
			# 		flash[:info] = "El estudiante ya posee más de 2 asignaturas inscritas en el periodo actual. Por favor haga clic <a href='#{usuario_path(params[:id])}' class='btn btn-primary btn-sm'>aquí</a> para mayor información y realizar ajustes sobre las asignaturas" 
			# 	end
			# end
			@titulo = "Inscripción para el período #{current_periodo.id} - Paso 1 - Buscar Estudiante"
			estudiantes = Estudiante.last(5).sort_by{|e| e.usuario.apellidos}
			@estudiantes = estudiantes
		end

		def seleccionar
			unless @estudiante = Estudiante.where(usuario_id: params[:id]).limit(1).first
				flash[:info] = "El estudiante no encontrado"
				redirect_to action: 'buscar_estudiante'#, id: params[:id]
			else 
				@vertical = 'flex-column'
				@orientacion = "vertical"
				@admin_inscripcion = true 
				@row = 'row'
				@col2 = 'col-2'
				@col10 = 'col-10'
				@inscripciones = Inscripcionseccion.joins(:seccion).where(estudiante_id: params[:id], "secciones.periodo_id" => current_periodo.id)

				@ids_asignaturas = @inscripciones.collect{|i| i.seccion.asignatura_id} if @inscripciones

				@titulo = "Inscripción para el período #{current_periodo} - Paso 2 - Seleccionar Secciones"

				@escuelas = current_admin.escuelas #Escuela.where(id: estudiante.escuela_id)
				
				#@escuelas = escuelas
				#@estudiante = estudiante
				# sel = @escuelas.count > 1 : @escuelas.ids.to_s : @escuelas.ids
				@secciones_disponibles = current_periodo.secciones.joins(:escuela).where("escuelas.id = ?", @escuelas.ids).references(:escuelas)

				#@secciones_disponibles = @estudiante.escuela.secciones.del_periodo(current_periodo.id)
				#@secciones_disponibles = secciones_disponibles #Seccion.joins(:asignaturas).del_periodo(current_periodo.id).where('asi')
			end
		end

		def inscribir

			secciones = params[:secciones]
			guardadas = 0
			id = params[:id]
			begin
				secciones.each_pair do |sec_id, sec_num|
					seccion = Seccion.find sec_id
					if seccion.inscripcionsecciones.create!(estudiante_id: id)
						guardadas += 1
					else
						flash[:error] = "#{es_se.errors.full_messages.join' | '}"
					end
					flash[:info] = "Para mayor información vaya al detalle del estudiante haciendo clic <a href='#{usuario_path(id)}' class='btn btn-primary btn-sm'>aquí</a> "
				end 
			rescue Exception => e
				flash[:error] = "Error Excepcional: #{e}"
			end
			flash[:success] = "Estudiante inscrito en #{guardadas} seccion(es)"
			redirect_to action: :resumen, id: id #, flash: flash
		end

		def resumen
			id = params[:id]
			@estudiante = Estudiante.find id
			@secciones = @estudiante.secciones.del_periodo current_periodo.id
			@titulo = "Inscripción para el período #{current_periodo.id} - Paso 3 - Resumen:"

		end

		def nuevo
			@accion = params[:accion]
			@controlador = params[:controlador]
			@secciones = CalSeccion.all
			@estudiante = CalEstudiante.find(params[:ci])
		end

		def crear
			id = params[:estudiante_id]
			seccion_id = (params[:seccion][:id]).to_i
			if Inscripcionseccion.where(estudiante_id: id, seccion_id: seccion_id).limit(1).first
				flash[:error] = "El Estudiante ya esta inscrito en esa sección"
			else
				ins = Inscripcionseccion.new
				ins.estudiante_id = id
				ins.seccion_id = seccion_id
				if ins.save
					flash[:success] = "Estudiante inscrito satisfactoriamente"
				else
					flash[:danger] = "Error al intentar inscribir en la sección: #{ins.errors.full_messages.to_sentence}"
				end
			end
			redirect_back fallback_location: "/usuarios/#{id}"
		end

		def destroy
			es = Inscripcionseccion.find params[:id]
			est = es.estudiante 
			if es.destroy
				flash[:info] = "Inscripción eliminado satisfactoriamente"
			else
				flash[:danger] = "El estudiante no pudo ser eliminado: #{es.errors.full_messages.to_sentence}"
			end
			redirect_back fallback_location: est.usuario

		end

		def set_retirar
			if es = Inscripcionseccion.find(params[:id])
				estado_anterior = es.estado

				# if params[:valor].eql? 0
				# 	es.estado = es.estado_segun_calificacion
				# else
				# 	es.estado = Inscripcionseccion.estados.key params[:valor]
				# end
				es.estado = Inscripcionseccion.estados.key params[:valor].to_i
				
				if es.save
					if es.retirado?
						flash[:success] = "Se retiró a #{es.estudiante.usuario.nickname} de la sección #{es.seccion.descripcion}."
						info_bitacora "Se retiró al estudiante #{es.estudiante.usuario.descripcion} de la sección #{es.seccion.descripcion}. Estado anterior: #{estado_anterior.upcase}" , Bitacora::ACTUALIZACION, es
					else
						flash[:success] = "Se reinscribió a #{es.estudiante.usuario.nickname} de la sección #{es.seccion.descripcion}."
						info_bitacora "Se reinscribió al estudiante #{es.estudiante.usuario.descripcion} de la sección #{es.seccion.descripcion}. Estado anterior: #{estado_anterior.upcase}" , Bitacora::ACTUALIZACION, es
					end
				else
					flash[:error] = "No se pudo cambiar el valor de retiro, intentelo de nuevo: #{es.errors.full_messages.join' | '}"
				end				
			else
				flash[:error] = "El estudiante no fue encontrado en la sección especificada"
			end
			redirect_to es.estudiante.usuario

		end


	end
end