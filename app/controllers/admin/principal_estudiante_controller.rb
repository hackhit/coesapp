module Admin
	class PrincipalEstudianteController < ApplicationController
		before_action :filtro_logueado
		before_action :filtro_estudiante

		def index
			@usuario = Usuario.find session[:estudiante_id]
			@estudiante = @usuario.estudiante #Estudiante.where(usuario_ci: session[:usuario_id]).limit(1).first
			@periodo_actual = ParametroGeneral.periodo_actual_id
			@titulo = "#{@usuario.nombre_completo} - Período: #{@periodo_actual} - #{@estudiante.escuela.descripcion.titleize}"

			@periodos = Periodo.order("inicia DESC").all

			@inscripciones = Inscripcionseccion.joins(:seccion).where(estudiante_id: @estudiante.usuario_id).order("secciones.asignatura_id DESC")

			if @estudiante.combinaciones.count < 1
				@idiomas = Departamento.all
				@programaciones = Departamento.all
			else
				@programaciones = Departamento.where(:id => [ "#{@estudiante.idioma1.id}" ,"#{@estudiante.idioma2.id}"])
			end
			@total = @inscripciones.all.count

		end

	end
end