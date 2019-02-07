module Admin
	class PrincipalProfesorController < ApplicationController

		before_action :filtro_logueado
		before_action :filtro_profesor

		def index
			@usuario = Usuario.find session[:profesor_id]
			@titulo = "Principal - Profesores"	
			@profesor = Profesor.find (session[:profesor_id])
			@secciones_pendientes = @profesor.secciones.sin_calificar.order('periodo_id DESC, numero ASC')
			@secciones_calificadas = @profesor.secciones.calificadas.order('periodo_id DESC, numero ASC')
			@secciones_secundarias = @profesor.secciones_secundarias.order('periodo_id DESC, numero ASC')#.where(periodo_id: @periodo_actual_id)
		end

	end
end