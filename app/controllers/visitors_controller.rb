class VisitorsController < ApplicationController
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
      roles = usuario.roles_generales
      if roles.size == 0
        reset_session
        flash[:error] = "Usuario sin rol"
        redirect_to root_path
        return
      elsif roles.size == 1
        cargar_parametros_generales
        redirect_to :action => "un_rol", :tipo => roles.first
        return
      else
        cargar_parametros_generales
        flash[:warning] = "Tiene más de un rol, selecciona uno de ellos"
        redirect_to :action => "seleccionar_rol"
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

  def un_rol 
    tipo = params[:tipo]
    usuario = Usuario.find session[:usuario_ci]

    gen = "@"
    gen = "a" if usuario.mujer?
    gen = "o" if usuario.hombre?

    flash[:success] = "Bienvenid#{gen} #{usuario.nombres}" 

    if tipo == "Administrador" && usuario.administrador
      session[:rol] = tipo
      session[:administrador_id] = usuario.administrador.id
      redirect_to principal_admin_index_path
    elsif tipo == "Profesor" && usuario.profesor
      session[:rol] = tipo
      session[:profesor_id] = usuario.profesor_id
      redirect_to principal_profesor_index_path
      return
    elsif tipo == "Estudiante"
      session[:rol] = tipo
      session[:estudiante_id] = usuario.estudiante_id
      redirect_to principal_estudiante_index_path
      return
    end
  end

  def cerrar_sesion
  	usuario = Usuario.find session[:usuario_ci]
    msg = "¡Hasta pronto #{usuario.nombres}!"    
    reset_session
    flash[:success] = msg
    redirect_to root_path
  end 

  def olvido_clave
  	usuario = Usuario.find session[:usuario_ci]
    if usuario
      # CalEstudianteMailer.olvido_clave(usuario).deliver  
      # info_bitacora "El usuario #{usuario.descripcion} olvido su clave y la pidio recuperar"
      flash[:success] = "#{usuario.nombres}, se ha enviado la clave al correo: #{usuario.correo_electronico}"
    else
      flash[:error] = "Usuario no registrado"
    end
      redirect_to root_path
  end


end
