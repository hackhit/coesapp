class VisitorsController < ApplicationController
    before_action :filtro_logueado, only: [:cerrar_sesion]

  layout 'visitors'

  def index
    aux = flash[:error]
    aux2 = flash[:danger]
    aux3 = flash[:success]
    aux4 = flash[:notice]
    reset_session
    flash[:error] = aux
    flash[:danger] = aux2
    flash[:success] = aux3
    flash[:notice] = aux4
    @carteleras = Cartelera.all.activas
  end

  def validar
    unless params[:usuario]
      flash[:error] = "Error, debe ingresar Cédula y contraseña"
      redirect_to root_path
      return
    end
    login = params[:usuario][:ci]
    clave = params[:usuario][:password]
    reset_session
    if usuario = Usuario.autenticar(login, clave)
      session[:usuario_ci] = usuario.id
      info_bitacora 'Inicio de sessión', nil, 'Session'
      roles = usuario.roles_generales
      if roles.size == 0
        reset_session
        flash[:error] = "Usuario sin rol"
        redirect_to root_path
        return
      elsif roles.size == 1
        cargar_parametros_generales
        redirect_to action: "un_rol", tipo: roles.first
        return
      else
        cargar_parametros_generales
        flash[:warning] = "Tiene más de un rol, selecciona uno de ellos"
        redirect_to action: "seleccionar_rol"
        return
      end
    end
    flash[:error] = "Error en cédula o contraseña"
    redirect_to root_path
  end 

  
  def seleccionar_rol    
    usuario = Usuario.find session[:usuario_ci]
    @roles = usuario.roles_generales
  end


  def cerrar_sesion
    usuario = Usuario.find session[:usuario_ci]
    info_bitacora 'Fin de sessión', nil, 'Session'
    msg = "¡Hasta pronto #{usuario.nombres}!"
    reset_session
    flash[:success] = msg
    redirect_to root_path
  end 

  def olvido_clave_guardar
    usuario = Usuario.where(ci: params[:id]).limit(1).first
    if usuario
      session[:usuario_ci] = usuario.ci
      ApplicationMailer.olvido_clave(usuario).deliver  
      info_bitacora 'Solicitó recuperación de clave', nil, 'Session'
      m = usuario.email
      flash[:success] = "#{usuario.nombres}, se ha enviado la clave al correo: #{m[0]}...#{m[4..m.size]}"
    else
      flash[:error] = "Usuario no registrado"
    end
      redirect_to root_path
  end

  def un_rol 
    tipo = params[:tipo]
    usuario = Usuario.find session[:usuario_ci]

    gen = usuario.genero

    flash[:success] = "Bienvenid#{gen} #{usuario.nombres}" 

    if tipo == "Administrador" && usuario.administrador
      session[:rol] = tipo
      session[:administrador_id] = usuario.administrador.id
      session['periodo_actual_id'] = inicial_current_periodo.id 
      
      redirect_to periodos_path  
      # if current_admin.maestros?
      #   redirect_to periodos_path  
      # else
      #   redirect_to principal_admin_index_path
      # end
    elsif tipo == "Profesor" && usuario.profesor
      session[:rol] = tipo
      session[:profesor_id] = usuario.profesor.id
      session['periodo_actual_id'] = inicial_current_periodo.id 
      
      redirect_to principal_profesor_index_path
      return
    elsif tipo == "Estudiante"
      session[:rol] = tipo
      session[:estudiante_id] = usuario.estudiante.id
      session['periodo_actual_id'] = inicial_current_periodo.id 
      redirect_to principal_estudiante_index_path
      return
    end
  end

end
