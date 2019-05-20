module Admin
	class PrincipalEstudianteController < ApplicationController
		before_action :filtro_logueado
		before_action :filtro_estudiante

		def index
			@usuario = Usuario.find session[:estudiante_id]
			usuario = Usuario.find session[:estudiante_id]
			estu = usuario.estudiante
			@estudiante = @usuario.estudiante #Estudiante.where(usuario_ci: session[:usuario_id]).limit(1).first
			
			@titulo = "#{@usuario.descripcion} - Período: #{current_periodo.id} - #{@estudiante.escuelas.collect{|es| es.descripcion}.to_sentence.upcase}"

			@periodos = Periodo.order("inicia DESC").all

			@inscripciones = Inscripcionseccion.joins(:seccion).where(estudiante_id: @estudiante.usuario_id).order("secciones.asignatura_id DESC")

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