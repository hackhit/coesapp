module Admin
	class InscripcionSeccionController < ApplicationController

		before_action :filtro_logueado
		before_action :filtro_administrador
		
		def buscar_estudiante
			@periodo_actual_id = ParametroGeneral.periodo_actual_id

			if params[:id]
				@inscripciones = InscripcionEnSeccion.joins(:seccion).where(estudiante_id: params[:id], "secciones.periodo_id" => @periodo_actual_id)
				if @inscripciones.count > 2
					flash[:info] = "El estudiante ya posee más de 2 asignaturas inscritas en el periodo actual. Por favor haga clic <a href='#{usuario_path @inscripciones.first.estudiante}' class='btn btn-primary btn-sm'>aquí</a> para mayor información y realizar ajustes sobre las asignaturas" 
				end
			end
			@titulo = "Inscripción para el período #{@periodo_actual_id} - Paso 1 - Buscar Estudiante"
			@estudiantes = Estudiante.all.sort_by{|e| e.usuario.apellidos}
		end

		def seleccionar
			@periodo_actual_id = ParametroGeneral.periodo_actual_id
			@inscripciones = InscripcionEnSeccion.joins(:seccion).where(estudiante_id: params[:id], "secciones.periodo_id" => @periodo_actual_id)

			@estudiante = Estudiante.find params[:id]
			@titulo = "Inscripción para el período #{@periodo_actual_id} - Paso 2 - Seleccionar Secciones"
			if @inscripciones.count > 2
				flash[:info] = "El estudiante ya posee más de 2 asignaturas inscritas en el periodo actual. Por favor haga clic <a href='#{usuario_path @inscripciones.first.estudiante}' class='btn btn-primary btn-small'>aquí</a> para para mayor información y realizar ajustes sobre las asignaturas" 
				redirect_to action: 'buscar_estudiante', id: params[:id]
			else		
				@departamentos = Departamento.all
				@secciones_disponibles = Seccion.del_periodo_actual
			end
		end

		def inscribir
			@periodo_actual_id = ParametroGeneral.periodo_actual_id
			secciones = params[:secciones]
			guardadas = 0
			id = params[:id]
			begin
				secciones.each_pair do |sec_id, sec_num|
					seccion = Seccion.find sec_id
					if seccion.inscripciones_en_secciones.create!(estudiante_id: id, tipo_estado_inscripcion_id: 'INS')
						guardadas += 1
					else
						flash[:error] = "#{es_se.errors.full_messages.join' | '}"
					end
					flash[:info] = "Para mayor información vaya al detalle del estudiante haciendo clic <a href='/admin/usuarios/#{id}' class='btn btn-primary btn-sm'>aquí</a> "
				end 
			rescue Exception => e
				flash[:error] = "Error Excepcional: #{e}"
			end
			flash[:success] = "Estudiante inscrito en #{guardadas} seccion(es)"
			redirect_to action: :resumen, id: id#, flash: flash
		end

		def resumen
			id = params[:id]
			@periodo_actual_id = ParametroGeneral.periodo_actual_id
			@estudiante = Estudiante.find id
			@secciones = @estudiante.secciones.del_periodo_actual
			@titulo = "Inscripción para el período #{@periodo_actual_id} - Paso 3 - Resultados y Resumen: #{@estudiante.usuario.descripcion}"

		end

		def nuevo
			@accion = params[:accion]
			@controlador = params[:controlador]
			@secciones = CalSeccion.all
			@estudiante = CalEstudiante.find(params[:ci])
		end

		def crear
			ci = params[:ci]
			numero, cal_materia_id, periodo_id = params[:cal_seccion][:id].split(",")
			if InscripcionEnSeccion.where(:cal_estudiante_ci => ci, :numero => numero, :cal_materia_id => cal_materia_id, :periodo_id => periodo_id).limit(1).first
				flash[:error] = "El Estudiante ya esta inscrito en esa sección"
			else
				if InscripcionEnSeccion.create(:cal_estudiante_ci => ci, :numero => numero, :cal_materia_id => cal_materia_id, :periodo_id => periodo_id, :cal_tipo_estado_inscripcion_id => 'INS', :cal_tipo_estado_calificacion_id => 'SC')
					flash[:success] = "Estudiante inscrito satisfactoriamente"
				else
					flash[:error] = "No se pudo incorporar al estudiante en la seccion correspondiente, intentelo de nuevo"
				end
			end
			# redirect_to :controller => params[:controlador], :action => params[:accion], :ci => ci, flash: flash[:success]

			redirect_to({ :controller => params[:controlador], :action => params[:accion], :ci => ci}, flash: flash) and return
		end

		def eliminar
			# ci = params[:ci]
			# numero, cal_materia_id, periodo_id = params[:cal_seccion_id].split(",")		
			id = params[:id]
			ci = id[0]
			if es = InscripcionEnSeccion.find(id)
				if es.destroy
					flash[:success] = "El estudiante fue eliminado de la sección correctamente, ci:#{ci}"
				else
					flash[:error] = "El estudiante no pudo ser eliminado"
				end				
			else
				flash[:error] = "El estudiante no fue encontrado en la sección especificada"
			end
			redirect_to({:controller => params[:controlador], :action => params[:accion], :ci => ci}, flash: flash) and return
			# redirect_to :controller => params[:controlador], :action => params[:accion], :ci => ci
		end

		def set_retirar
			valor = 
			id = params[:id]
			if es = InscripcionEnSeccion.find(id)
				es.cal_tipo_estado_inscripcion_id = params[:valor]
				if es.save
					flash[:success] = "El cambio el valor de retiro de #{es.cal_estudiante.cal_usuario.nickname} de la sección #{es.cal_seccion.descripcion} se realizó correctamente"
				else
					flash[:error] = "No se pudo cambiar el valor de retiro, intentelo de nuevo: #{es.errors.full_messages.join' | '}"
				end				
			else
				flash[:error] = "El estudiante no fue encontrado en la sección especificada"
			end
			redirect_to :back

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