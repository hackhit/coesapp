class ApplicationController < ActionController::Base
	protect_from_forgery
	helper_method :current_usuario 

	private  

	# def info_bitacora(descripcion, estudiante_ci = nil)
	#   usuario_ci = (session[:usuario]) ? session[:usuario].ci : nil
	#   estudiante_ci = (session[:estudiante]) ? session[:estudiante].usuario_ci : nil
	#   administrador_ci = (session[:administrador]) ? session[:administrador].usuario_ci : nil                     
		
	#   Bitacora.info(
	#     :descripcion => descripcion, 
	#     usuario_ci: usuario_ci,
	#     :estudiante_usuario_ci =>estudiante_ci,
	#     :administrador_usuario_ci =>administrador_ci,
	#     :ip_origen => request.remote_ip
	#     )
	# end

	def current_usuario
		@current_usuario ||= Usuario.find(session[:usuario_ci]) if session[:usuario_ci]
	end

	def cargar_parametros_generales   
		session[:parametros] = {}
		ParametroGeneral.all.each{|registro|
			session[:parametros][registro.id.downcase.to_sym] = registro.valor.strip
		}
	end

	def filtro_logueado
		unless session[:usuario_ci]
			reset_session
			flash[:alert] = "Debe iniciar sesión"
			redirect_to root_path
			return false
		end
	end
	
	def filtro_administrador
		unless session[:administrador_ci]
			reset_session
			flash[:alert] = "Debe iniciar sesión como Administrador"  
			redirect_to root_path
			return false
		end
	end

	def filtro_admin_profe
		unless session[:administrador_ci] or session[:profesor_ci] 
			reset_session
			flash[:alert] = "Debe iniciar sesión como Profesor o Administrador"  
			redirect_to root_path
			return false
		end
	end

	def filtro_profesor
		unless session[:profesor_ci]
			reset_session
			flash[:alert] = "Debe iniciar sesión como Profesor"  
			redirect_to root_path
			return false
		end
	end

	def filtro_estudiante
		unless session[:estudiante_ci]
			reset_session
			flash[:alert] = "Debe iniciar sesión como Profesor"  
			redirect_to root_path
			return false
		end
	end

end
