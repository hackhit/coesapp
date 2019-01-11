class ApplicationController < ActionController::Base
	protect_from_forgery
	helper_method :current_usuario 

	private  

	def info_bitacora(descripcion, estudiante_ci = nil)
	  usuario_ci = session[:usuario_ci]
	  estudiante_ci = session[:estudiante_ci]
	  administrador_ci = session[:administrador_id] ? session[:administrador].usuario_ci : nil                     
		
	  Bitacora.info(
	    :descripcion => descripcion, 
	    usuario_ci: usuario_ci,
	    :estudiante_usuario_ci =>estudiante_ci,
	    :administrador_usuario_ci =>administrador_ci,
	    :ip_origen => request.remote_ip
	    )
	end

	def current_usuario
		@current_usuario ||= Usuario.find(session[:usuario_ci]) if session[:usuario_ci]
	end

	def current_admin
		@current_admin ||= Administrador.find(session[:administrador_id]) if session[:administrador_id]
	end

	def cargar_parametros_generales   
		session[:parametros] = {}
		ParametroGeneral.all.each{|registro|
			session[:parametros][registro.id.downcase.to_sym] = registro.valor.strip
		}
	end

	def filtro_ninja!
		unless session[:usuario_ci].eql? '15573230'
			reset_session
			flash[:danger] = "¡Buen intento! Debes tener Dunamis para realizar esta acción"
			redirect_to root_path
			return false
		end		
	end

	def filtro_logueado
		unless session[:usuario_ci]
			reset_session
			flash[:danger] = "Debe iniciar sesión"
			redirect_to root_path
			return false
		end
	end
	
	def filtro_administrador
		unless session[:administrador_id]
			reset_session
			flash[:danger] = "Debe iniciar sesión como Administrador"  
			redirect_to root_path
			return false
		end
	end

	def filtro_super_admin!
		if !session[:administrador_id] or (current_admin and !current_admin.super?)
			reset_session
			flash[:danger] = "Debe tener máximos privilegios administrativos. Solicite esta acción a su superior"
			redirect_to root_path
			return false
		end		
	end

	def filtro_admin_puede_escribir
		if !session[:administrador_id] or (current_admin and !current_admin.puede_escribir?)
			reset_session
			flash[:danger] = "Debe iniciar sesión como Administrador con privilegios de escritura"
			redirect_to root_path
			return false
		end
	end

	def filtro_admin_escritor_o_profe
		if !session[:administrador_id] or (current_admin and !current_admin.puede_escribir?) or !session[:profesor_id] 
			reset_session
			flash[:danger] = "Debe iniciar sesión como Profesor o Administrador"  
			redirect_to root_path
			return false
		end
	end


	def filtro_admin_profe
		unless session[:administrador_id] or session[:profesor_id] 
			reset_session
			flash[:danger] = "Debe iniciar sesión como Profesor o Administrador"  
			redirect_to root_path
			return false
		end
	end

	def filtro_profesor
		unless session[:profesor_id]
			reset_session
			flash[:danger] = "Debe iniciar sesión como Profesor"  
			redirect_to root_path
			return false
		end
	end

	def filtro_estudiante
		unless session[:estudiante_id]
			reset_session
			flash[:danger] = "Debe iniciar sesión como Profesor"  
			redirect_to root_path
			return false
		end
	end

end
