module Admin
	class InscripcionseccionesController < ApplicationController
		before_action :filtro_logueado
		before_action :filtro_administrador#, only: [:destroy]
		# before_action :filtro_admin_mas_altos!, except: [:destroy]
		# before_action :filtro_ninja!, only: [:destroy]

		before_action :set_inscripcionseccion, only: [:cambiar_seccion]

		# def set_pci
		# 	inscripcion = Inscripcionseccion.find params[:inscripcionseccion_id]
		# 	inscripcion.pci_escuela_id = params[:escuela_pci_id]
		# end

		def cambiar_seccion
			seccion_anterior = @inscripcionseccion.seccion
			@inscripcionseccion.seccion_id = params[:inscripcionseccion][:seccion_id]
			if @inscripcionseccion.save
				flash[:success] = 'Cambio de sección exitoso'
				info_bitacora "Cambio de sección de la #{seccion_anterior.descripcion} (#{seccion_anterior.id}) a la #{@inscripcionseccion.seccion.descripcion} (#{@inscripcionseccion.seccion.id}) al estudiante #{@inscripcionseccion.estudiante.usuario.descripcion}" , Bitacora::ACTUALIZACION, @inscripcionseccion
			else
				flash[:danger] = "Error al intentar realizar el cambio en la inscripción: #{@inscripcionseccion.errors.full_messages.to_sentence}"
			end
			redirect_back fallback_location: @inscripcionseccion.estudiante.usuario
		end

		def set_escuela_pci
			inscripcion = Inscripcionseccion.find params[:id]
			inscripcion.pci_escuela_id = params[:pci_escuela_id]

			inscripcion.escuela_id = params[:pci_escuela_id]

			inscripcion.pci = true

			# respond_to do |format|
			# 	if inscripcion.save
			# 		format.json {render json: {html: '¡Asociación exitosa!'}, status: :ok}
			# 	end
			# end

			if inscripcion.save
				flash[:success] = '¡Escuela asignada a Pci!'
			else
				flash[:error] = "Error: #{inscripcion.errors.full_messages.to_sentence}"
			end
			redirect_back fallback_location: inscripcion.estudiante.usuario 
		end

		def index
			@escuela = Escuela.find params[:escuela_id]
			# @inscripciones = escuela.inscripcionsecciones.del_periodo(params[:id]).estudiantes_inscritos_con_creditos
			# @inscripciones = @escuela.inscripcionsecciones.del_periodo(params[:periodo_id]).estudiantes_inscritos_con_creditos#.estudiantes_inscritos
			@inscripciones = @escuela.inscripcionsecciones.del_periodo(params[:periodo_id]).joins(:usuario).order("usuarios.apellidos ASC").joins(:asignatura).group(:estudiante_id).select('estudiante_id, usuarios.apellidos apellidos, usuarios.nombres nombres, SUM(asignaturas.creditos) total_creditos, COUNT(*) asignaturas, SUM(IF (estado = 1, asignaturas.creditos, 0)) aprobados')
			@titulo = "Inscripciones para el período #{params[:periodo_id]} en la escuela #{@escuela.descripcion} (#{@inscripciones.size.count})"
		end

		def cambiar_calificacion

			inscripcion = Inscripcionseccion.find params[:inscripcionseccion_id]

			if inscripcion.asignatura.numerica3? and params[:tipo_calificacion_id].eql? TipoCalificacion::PARCIAL
				params[:valor] = nil if params[:valor].eql? '-1'
				inscripcion[params[:calificacion_parcial]] = params[:valor]

				if params[:calificacion_parcial].eql? 'primera_calificacion'
					inscripcion.estado = :trimestre1
					p 'solicitud de modificacion de estado a trimestre1'
				elsif params[:calificacion_parcial].eql? 'segunda_calificacion'
					inscripcion.estado = :trimestre2
					p 'solicitud de modificacion de estado a trimestre2'
				else
					if params[:valor].nil?
						if inscripcion.segunda_calificacion
							inscripcion.estado = :trimestre2
						elsif inscripcion.primera_calificacion
							inscripcion.estado = :trimestre1
						else
							inscripcion.estado = 'sin_calificar'
						end
					end
				end

				inscripcion.calificacion_final = nil if (inscripcion.primera_calificacion.nil? or inscripcion.segunda_calificacion.nil? or inscripcion.tercera_calificacion.nil?)

			elsif inscripcion.seccion.asignatura.absoluta?
				inscripcion.estado = Inscripcionseccion.estados.key params[:calificacion_final].to_i
				inscripcion.calificacion_posterior = nil
				inscripcion.calificacion_final = inscripcion.aprobado? ? 20 : 1
			else
				params[:tipo_calificacion_id] = 'NF' if params[:tipo_calificacion_id].nil?

				if (params[:tipo_calificacion_id].eql? TipoCalificacion::DIFERIDO) or (params[:tipo_calificacion_id].eql? TipoCalificacion::REPARACION)
					calificacion_anterior = inscripcion.calificacion_posterior
					inscripcion.calificacion_posterior = params[:calificacion_posterior] ? params[:calificacion_posterior].to_i : params[:calificacion_final].to_i

				elsif params[:tipo_calificacion_id].eql? TipoCalificacion::PI
					calificacion_anterior = inscripcion.calificacion_final
					inscripcion.calificacion_final = 1 
					params[:calificacion_final] = 1
					inscripcion.calificacion_posterior = nil 
				else
					calificacion_anterior = inscripcion.calificacion_final
					inscripcion.calificacion_final = params[:calificacion_final].to_i
					inscripcion.calificacion_posterior = nil
				end

				if inscripcion.calificacion_final.to_i.eql? 0 or inscripcion.calificacion_final.nil?

					inscripcion.primera_calificacion = inscripcion.calificacion_final
					inscripcion.segunda_calificacion = inscripcion.calificacion_final
					inscripcion.tercera_calificacion = inscripcion.calificacion_final

				end

				inscripcion.estado = inscripcion.estado_segun_calificacion
			end

			inscripcion.tipo_calificacion_id = params[:tipo_calificacion_id]

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

				format.json {render json: inscripcion.save, status: :ok}


			end

		end
		
		def buscar_estudiante
			@titulo = "Inscripción para el período #{current_periodo.id} - Paso 1 - Buscar Estudiante"
			estudiantes = Estudiante.last(5).sort_by{|e| e.usuario.apellidos}
			@estudiantes = estudiantes
		end

		def seleccionar
			unless @estudiante = Estudiante.where(usuario_id: params[:id]).limit(1).first
				flash[:info] = "El estudiante no encontrado"
				redirect_to action: 'buscar_estudiante'#, id: params[:id]
			else 
				session[:inscripcion_estudiante_id] = @estudiante.id
				@asignatura = Asignatura.find session[:asignatura] if session[:asignatura]
				
				inscripciones = @estudiante.inscripciones
				@inscripciones = inscripciones.del_periodo(current_periodo.id) 

				if inscripciones
					@ids_asignaturas = @inscripciones.collect{|i| i.seccion.asignatura_id} 
					@ids_aprobadas = inscripciones.aprobadas.collect{|i| i.seccion.asignatura_id}

					p "  Resultado: #{session[:asignatura]}   ".center(200, "?")

            		@incritar_o_aprobadas = ((@ids_aprobadas and (@ids_aprobadas.include? session[:asignatura])) or (@ids_asignaturas and (@ids_asignaturas.include? session[:asignatura])))
				end

				@titulo = "Inscripción para el período #{current_periodo.id} - #{@ids_asignaturas.include? session[:asignatura]} - Paso 2 - Seleccionar Secciones"

				@escuelas = current_admin.escuelas.merge @estudiante.escuelas 

				@creditLimits = current_periodo.anual? ? 49 : 25

				aux = current_periodo.escuelas.merge @estudiante.escuelas
				@creditLimits = 31 if aux.ids.include? 'COMU'
				@creditLimits *= aux.count
				
			end

		end

		def inscribir
			secciones = params[:secciones]
			guardadas = 0
			id = params[:id]
			asignaturas_pci_error = []
			asignaturas_impropias = []
			begin
				secciones.each_pair do |sec_id, pci_escuela_id|
					seccion = Seccion.find sec_id
					ins = Inscripcionseccion.new
					ins.seccion_id = seccion.id
					ins.estudiante_id = id
					if pci_escuela_id and !(pci_escuela_id.eql? 'on')

						unless seccion.pci?
							# Error:
							asignaturas_pci_error << seccion.asignatura_id
						else
							escuela = Escuela.find pci_escuela_id
							ins.pci_escuela_id = escuela.id 
							ins.escuela_id = escuela.id
							ins.pci = true 
						end
					elsif ins.estudiante.escuelas.include? seccion.escuela
						ins.escuela_id = seccion.escuela.id
					else
						asignaturas_impropias << seccion.asignatura_id
					end

					if ins.save
						info_bitacora "Inscripción en #{ins.seccion.descripcion} (#{ins.asignatura.id}). Id inscripcion: #{ins.id}" , Bitacora::CREACION, ins.estudiante						
						guardadas += 1
					else
						flash[:error] = "#{ins.errors.full_messages.join' | '}"
					end
					flash[:info] = "Para mayor información vaya al detalle del estudiante haciendo clic <a href='#{usuario_path(id)}' class='btn btn-primary btn-sm'>aquí</a> "
				end 
			rescue Exception => e
				flash[:error] = "Error Excepcional: #{e}"
			end
			flash[:success] = "Estudiante inscrito en #{guardadas} seccion(es)"
			flash[:danger] = "La(s) asignatura(s) con código(s): #{asignaturas_pci_error.to_sentence} se intenta(n) inscribir como PCI, sin embargo para este periodo no está(n) ofertada(s) como tal. Por favor, corrija el error e inténtelo de nuevo." if asignaturas_pci_error.any?
			
			flash[:danger] = "La(s) asignatura(s) con código(s): #{asignaturas_impropias.to_sentence} se intenta(n) inscribir inapropiadamente. Por favor, corrija el error e inténtelo nuevamente." if asignaturas_impropias.any?

			redirect_to action: :resumen, id: id

		end

		def resumen
			session[:inscripcion_estudiante_id] = nil
			id = params[:id]
			@estudiante = Estudiante.find id
			@inscripciones = @estudiante.inscripcionsecciones.del_periodo(current_periodo.id)#.sort {|a,b| a.descripcion(current_periodo.id) <=> b.descripcion(current_periodo.id)}
			# @secciones = @estudiante.inscripcionsecciones.del_periodo current_periodo.id
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
				if !(ins.estudiante.escuelas.include? ins.seccion.escuela)
					flash[:danger] = 'La asignatura debe pertenecer a la Escuela'
				else
					ins.escuela_id = ins.seccion.escuela.id
					if ins.save
						flash[:success] = "Estudiante inscrito satisfactoriamente"
						info_bitacora "Inscripción directa en #{ins.seccion.descripcion} (#{ins.asignatura.id}). Id inscripcion: #{ins.id}" , Bitacora::CREACION, ins.estudiante
					else
						flash[:danger] = "Error al intentar inscribir en la sección: #{ins.errors.full_messages.to_sentence}"
					end
				end
			end
			redirect_back fallback_location: "/usuarios/#{id}"
		end

		def destroy
			es = Inscripcionseccion.find params[:id]
			sec = es.seccion
			est = es.estudiante 
			if es.destroy
				info_bitacora "Eliminada inscripción en #{sec.descripcion} (#{sec.asignatura_id})" , Bitacora::ELIMINACION, est

				flash[:info] = "Inscripción eliminado satisfactoriamente"
			else
				flash[:danger] = "El estudiante no pudo ser eliminado: #{es.errors.full_messages.to_sentence}"
			end
			redirect_back fallback_location: est.usuario

		end

		def cambiar_estado
			if es = Inscripcionseccion.find(params[:id])
				estado_anterior = es.estado
				es.estado = Inscripcionseccion.estados.key params[:estado].to_i

				if es.save
					flash[:success] = "Se guardó el estado #{es.estado} del estudiante #{es.estudiante.usuario.descripcion} en la sección #{es.seccion.descripcion}."
					info_bitacora "Cambio de estado del estudiante #{es.estudiante_id} de #{estado_anterior} a #{es.estado}", Bitacora::ACTUALIZACION, es
				else
					flash[:error] = "No se pudo cambiar el valor de retiro, intentelo de nuevo: #{es.errors.full_messages.join' | '}"
				end
			else
				flash[:error] = "El estudiante no fue encontrado en la sección especificada"
			end

			if es.grado.posible_graduando?
				tr = view_context.render partial: '/admin/grados/detalle_registro', locals: {registro: es.grado, estado: 2}
			elsif es.grado.tesista?
				tr = view_context.render partial: '/admin/grados/detalle_registro', locals: {registro: es.grado, estado: 1}
			else
				tr = ''
			end

			respond_to do |format|
				format.html { redirect_to es.estudiante.usuario}
				format.json do 
					flash[:success] = flash[:error] = nil
					msg = "Cambio de estado de #{es.estudiante.usuario.descripcion}"
					render json: {tr: tr, msg: msg}, status: :ok 
				end

	        end
		end
		private

		def set_inscripcionseccion
			@inscripcionseccion = Inscripcionseccion.find(params[:id])
		end

	end
end