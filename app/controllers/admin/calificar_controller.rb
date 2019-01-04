module Admin
	class CalificarController < ApplicationController

		before_action :filtro_logueado
		before_action :filtro_admin_profe
		# OJO: POR REVISAR
		def seleccionar_seccion
			@profesor = Profesor.find (session[:profesor_id])
			@periodo_actual = ParametroGeneral.periodo_actual_id
			@titulo = "Secciones disponibles para este período #{@periodo_actual.id}"
			@secciones = @profesor.secciones.where(:semestre_id => @periodo_actual.id)
			@secciones_secundarias = @profesor.secciones_secundarias.where(:periodo_id => @periodo_actual.id)
		end

		def ver_seccion
			id = 
			@seccion = Seccion.find params[:id]

			@estudiantes_secciones = @seccion.inscripcionsecciones.sort_by{|h| h.estudiante.usuario.apellidos}

			@titulo = "Sección: #{@seccion.descripcion} - Período #{@seccion.periodo_id}"
			if @seccion.asignatura.catedra_id.eql? 'IB' or @seccion.asignatura.catedra_id.eql? 'LIN' or @seccion.asignatura.catedra_id.eql? 'LE'
				@p1 = 25 
				@p2 =35
				@p3 = 40
			else
				@p1 = @p2 =30
				@p3 = 40
			end

			@secundaria = true if params[:secundaria]
		end

		def calificar

			id = params[:id]

			@seccion = Seccion.find(id.split(" "))

			@estudiantes = params[:est]

			@estudiantes.each_pair do |ci,valores|

				@inscripcionsecciones = @seccion.inscripcionsecciones.where(estudiante_id: id).limit(0).first
				
				if valores['pi']
					tipo_estado_calificacion_id = 'PI'
				else
					if valores[:calificacion_final].to_f >= 10
						tipo_estado_calificacion_id = 'AP'
					else 
						tipo_estado_calificacion_id = 'RE'
					end
				end
				valores['tipo_estado_calificacion_id'] = tipo_estado_calificacion_id
				unless @estudiante_seccion.update_attributes(valores)
					flash[:danger] = "No se pudo guardar la calificación."
					break
				end

			end
			@seccion.calificada = true
			calificada = @seccion.save

			flash[:success] = "Calificaciones guardada satisfactoriamente." if calificada

			if session[:administrador]
				redirect_to :controller => 'principal_admin'
			else
				redirect_to :action => "ver_seccion", :id => @estudiante_seccion.seccion.id
			end
		end

		def descargar_notas
			id = params[:id]
			seccion = Seccion.find(id)
			pdf = DocumentosPDF.notas seccion
			unless send_data pdf.render,:filename => "notas_#{seccion.asignatura_id}_#{seccion.numero}.pdf",:type => "application/pdf", :disposition => "attachment"
		    	flash[:mensaje] = "en estos momentos no se pueden descargar las notas, intentelo luego."
		    end
			# redirect_to :action => 'index'      
		end


		def importar_secciones
			data = File.readlines("AlemIV.rtf") #read file into array
			data.map! {|line| line.gsub(/world/, "ruby")} #invoke on each line gsub
			File.open("test2.txt", "a") {|f| f.puts "Nueva Linea: #{data}"} #output data to other file
		end
	end
end