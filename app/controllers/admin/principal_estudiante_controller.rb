module Admin
	class PrincipalEstudianteController < ApplicationController
		before_action :filtro_logueado
		before_action :filtro_estudiante

		def index
			@usuario = Usuario.find session[:estudiante_id]
			usuario = Usuario.find session[:estudiante_id]
			estu = usuario.estudiante
			@estudiante = @usuario.estudiante #Estudiante.where(usuario_ci: session[:usuario_id]).limit(1).first
			
			@titulo = "#{@usuario.nombre_completo} - Período: #{current_periodo.id} - #{@estudiante.escuela.descripcion.titleize}"

			@periodos = Periodo.order("inicia DESC").all

			@inscripciones = Inscripcionseccion.joins(:seccion).where(estudiante_id: @estudiante.usuario_id).order("secciones.asignatura_id DESC")

			if @estudiante.combinaciones.count < 1
				@idiomas = estu.escuela.departamentos.reject{|i| i.id.eql? 'EG' or i.id.eql? 'TRA'; }
				# @idiomas = CalDepartamento.all.delete_if{|i| i.id.eql? 'EG' or i.id.eql? 'TRA'; }
				@programaciones = Departamento.all
			else
				@programaciones = Departamento.where(:id => [ "#{@estudiante.idioma1.id}" ,"#{@estudiante.idioma2.id}"])
			end
			@total = @inscripciones.all.count

		end

		def actualizar_idiomas
			estudiante = Estudiante.find params[:principal_estudiante_id]
			idiomas = params[:estudiante]
			if estudiante.combinaciones.create(periodo_id: current_periodo.id, idioma1_id: idiomas[:idioma1], idioma2_id: idiomas[:idioma2] )
				flash[:success] = "Combinación guardada con éxito."
			else
				flash[:error] = "No se pudo guardar la combinación. Diríjase al personal administrativo."
			end

			redirect_to action: :index

		end

	end
end