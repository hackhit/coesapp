module Admin
	class InscripcionseccionesController < ApplicationController
		before_action :filtro_logueado
		before_action :filtro_admin_mas_altos!, except: [:destroy]
		before_action :filtro_ninja!, only: [:destroy]
		
		def buscar_estudiante
			if params[:id]
				@inscripciones = Inscripcionseccion.joins(:seccion).where(estudiante_id: params[:id], "secciones.periodo_id" => current_periodo.id)
				if @inscripciones.count > 2
					flash[:info] = "El estudiante ya posee más de 2 asignaturas inscritas en el periodo actual. Por favor haga clic <a href='#{usuario_path(params[:id])}' class='btn btn-primary btn-sm'>aquí</a> para mayor información y realizar ajustes sobre las asignaturas" 
				end
			end
			@titulo = "Inscripción para el período #{current_periodo.id} - Paso 1 - Buscar Estudiante"
			@estudiantes = Estudiante.all.sort_by{|e| e.usuario.apellidos}
		end

		def seleccionar
			@vertical = 'flex-column'
			@orientacion = "vertical"
			@admin_inscripcion = true 
			@row = 'row'
			@col2 = 'col-2'
			@col10 = 'col-10'
			@inscripciones = Inscripcionseccion.joins(:seccion).where(estudiante_id: params[:id], "secciones.periodo_id" => current_periodo.id)

			@ids_asignaturas = @inscripciones.collect{|i| i.seccion.asignatura_id} if @inscripciones

			@estudiante = Estudiante.find params[:id]
			@titulo = "Inscripción para el período #{current_periodo} - Paso 2 - Seleccionar Secciones"
			if @inscripciones.count > 2
				flash[:info] = "El estudiante ya posee más de 2 asignaturas inscritas en el período actual. Por favor haga clic <a href='#{usuario_path @inscripciones.first.estudiante}' class='btn btn-primary btn-small'>aquí</a> para para mayor información y realizar ajustes sobre las asignaturas" 
				redirect_to action: 'buscar_estudiante', id: params[:id]
			else
				@escuelas = current_admin.escuelas	
				@secciones_disponibles = Seccion.del_periodo current_periodo.id
			end
		end

		def inscribir

			secciones = params[:secciones]
			guardadas = 0
			id = params[:id]
			begin
				secciones.each_pair do |sec_id, sec_num|
					seccion = Seccion.find sec_id
					if seccion.inscripcionsecciones.create!(estudiante_id: id, tipo_estado_inscripcion_id: 'INS')
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
			redirect_to action: :resumen, id: id#, flash: flash
		end

		def resumen
			id = params[:id]
			@estudiante = Estudiante.find id
			@secciones = @estudiante.secciones.del_periodo current_periodo.id
			@titulo = "Inscripción para el período #{current_periodo.id} - Paso 3 - Resultados y Resumen: #{@estudiante.usuario.descripcion}"

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
				ins.tipo_estado_inscripcion_id = 'INS'
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
				flash[:info] = "Estudiante eliminado satisfactoriamente"
			else
				flash[:danger] = "El estudiante no pudo ser eliminado: #{es.errors.full_messages.to_sentence}"
			end
			redirect_back fallback_location: est.usuario

		end

		def set_retirar
			if es = Inscripcionseccion.find(params[:id])
				es.tipo_estado_inscripcion_id = params[:valor]
				if es.save
					flash[:success] = "El cambio el valor de retiro de #{es.estudiante.usuario.nickname} de la sección #{es.seccion.descripcion} se realizó correctamente"
				else
					flash[:error] = "No se pudo cambiar el valor de retiro, intentelo de nuevo: #{es.errors.full_messages.join' | '}"
				end				
			else
				flash[:error] = "El estudiante no fue encontrado en la sección especificada"
			end
			redirect_to es.estudiante.usuario

		end

		# private
		# # Use callbacks to share common setup or constraints between actions.

		# 	def set_seccion
		# 		@seccion = Seccion.find(params[:id])
		# 	end

		# 	# Never trust parameters from the scary internet, only allow the white list through.
		# 	def seccion_params
		# 	params.require(:secciones).permit(:numero, :asignatura_id, :periodo_id, :profesor_id, :calificada, :capacidad).to_h
		# 	end

	end
end