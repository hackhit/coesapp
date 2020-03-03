class ApplicationController < ActionController::Base
	protect_from_forgery
	helper_method :current_usuario 
	helper_method :current_admin
	helper_method :current_profesor
	helper_method :current_estudiante
	helper_method :current_periodo
	helper_method :current_escuela

	private

	def info_bitacora_crud tipo, objeto, comentario = nil
		descripcion = Bitacora.tipos.key tipo
		info_bitacora "#{descripcion.upcase} de #{objeto.class.name.titleize} con id: #{objeto.id} ", tipo, objeto, comentario
	end

	def info_bitacora (descripcion, tipo = nil, objeto = nil, comentario = nil)
		tipo_objeto = id_objeto = nil
		if objeto.eql? 'Session'
			tipo_objeto = objeto 
		elsif !objeto.nil?
			id_objeto = objeto.id
			tipo_objeto = objeto.class.name
		end

		Bitacora.create!(
			descripcion: descripcion, 
			tipo: tipo,
			usuario_id: current_usuario.id,
			comentario: comentario,
			id_objeto: id_objeto,
			tipo_objeto: tipo_objeto,
			ip_origen: request.remote_ip
		)
	end

	def current_usuario
		@current_usuario ||= Usuario.find(session[:usuario_ci]) if session[:usuario_ci]
	end

	def current_admin
		@current_admin ||= Administrador.find(session[:administrador_id]) if session[:administrador_id]
	end

	def current_profesor
		@current_profesor ||= Profesor.find(session[:profesor_id]) if session[:profesor_id]
	end

	def current_estudiante
		@current_admin ||= Estudiante.find(session[:estudiante_id]) if session[:estudiante_id]
	end

	def current_periodo
		@current_periodo ||= Periodo.find(session['periodo_actual_id']) if session['periodo_actual_id']
	end

	def current_escuela
		if current_admin
			if current_admin.escuela
				return current_admin.escuela
			elsif current_admin.departamento
				return current_admin.departamento.escuela
			end
		elsif current_usuario
			if current_usuario.profesor and current_usuario.profesor.escuela
				return current_usuario.profesor.escuela
			elsif current_usuario.estudiante and current_usuario.estudiante.escuelas 
				return current_usuario.estudiante.escuelas.first
			end
		else
			return nil
		end
	end

	def filtro_autorizado

		accion = (!(controller_name.eql? 'secciones') and (action_name.eql? 'show')) ? 'index' : action_name
		funcion = Restringida.where(controlador: controller_name, accion: accion).first

		if funcion and current_usuario and (current_admin and !current_admin.maestros?) and not(current_usuario.autorizado?(controller_name, accion))
			msg = 'No posee los privilegios para ejecutar la acción solicitada'
			respond_to do |format|
				format.html do 
					flash[:danger] = msg
					redirect_back fallback_location: index2_secciones_path
				end
				format.json {render json: {data: msg, status: :success, type: :error} }
			end

			# render json: {data: msg, status: :success}
		end
	end


	# def filtro_autorizado

	# end

	def inicial_current_periodo
		escuela = current_escuela

		if escuela and escuela.periodos.count > 0 
			return escuela.periodos.order(:inicia).last 
		else
			return Periodo.order(:inicia).last
		end
	end

	def cargar_parametros_generales
		session[:parametros] = {}
		ParametroGeneral.all.each{|registro|
			session[:parametros][registro.id.downcase.to_sym] = registro.valor.strip
		}
	end

	def filtro_ninja!
		if !session[:administrador_id] or (current_admin and !current_admin.ninja?)
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
		if !session[:administrador_id] or (current_admin and !current_admin.maestros?)
			reset_session
			flash[:danger] = "Debe tener máximos privilegios administrativos. Solicite esta acción a su superior"
			redirect_to root_path
			return false
		end		
	end

	def filtro_admin_mas_altos!
		if !session[:administrador_id] or (current_admin and !current_admin.mas_altos?)
			reset_session
			flash[:danger] = "Debe iniciar sesión como Administrador con privilegios de escritura"
			redirect_to root_path
			return false
		end
	end



	def filtro_admin_altos!
		if !session[:administrador_id] or (current_admin and !current_admin.altos?)
			reset_session
			flash[:danger] = "Debe iniciar sesión como Administrador con privilegios de escritura"
			redirect_to root_path
			return false
		end
	end


	def filtro_admin_alto_o_profe
		if !session[:administrador_id] or (current_admin and !current_admin.alto?) or !session[:profesor_id] 
			reset_session
			flash[:danger] = "Debe iniciar sesión como Profesor o Administrador superior"  
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
			flash[:danger] = "Debe iniciar sesión como Estudiante"  
			redirect_to root_path
			return false
		end
	end

end
