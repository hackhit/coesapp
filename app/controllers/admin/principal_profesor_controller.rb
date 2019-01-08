module Admin
	class PrincipalProfesorController < ApplicationController

		before_action :filtro_logueado
		before_action :filtro_profesor

		def index
			@usuario = Usuario.find session[:profesor_id]
			@titulo = "Principal - Profesores"	
		end

	end
end