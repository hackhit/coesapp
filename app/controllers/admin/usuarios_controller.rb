module Admin
  class UsuariosController < ApplicationController
    before_action :filtro_logueado
    before_action :filtro_administrador, except: [:edit, :update]
    before_action :filtro_admin_mas_altos!, except: [:busquedas, :index, :show, :edit, :update]
    before_action :filtro_super_admin!, only: [:set_administrador, :set_estudiante, :set_profesor]
    before_action :filtro_ninja!, only: [:destroy, :delete_rol]

    before_action :set_usuario, except: [:index, :new, :create, :busquedas]

    # GET /usuarios
    # GET /usuarios.json

    def busquedas
      # @usuarios = Usuario.search(params[:term])
      if params[:estudiantes]
        @usuarios = Usuario.search(params[:term]).reject{|u| u.estudiante.nil?} 
      elsif params[:profesores]
        @usuarios = Usuario.search(params[:term]).reject{|u| u.profesor.nil?}
      else
        @usuarios = Usuario.search(params[:term])
      end
    end

    def index
      @titulo = 'Usuarios'

      if params[:search]
        @usuarios = Usuario.search(params[:search]).limit(50)
        if @usuarios.count > 0 && @usuarios.count < 50  
          flash[:success] = "Total de coincidencias: #{@usuarios.count}"
        elsif @usuarios.count == 0
          flash[:error] = "No se encontraron conincidencas. Intenta con otra búsqueda"
        else
          flash[:error] = "50 o más conincidencia. Puedes ser más explicito en la búsqueda. Recuerda que puedes buscar por CI, Nombre, Apellido, Correo Electrónico o incluso Número Telefónico"
        end
      else
        @usuarios = Usuario.limit(50).order("created_at, apellidos, nombres, ci")      
      end
    end

    def set_estudiante
      est = Estudiante.new
      est.usuario_id = @usuario.id
      est.escuela_id = params[:estudiante][:escuela_id]
      if est.save
        flash[:success] = 'Estudiante registrado con éxito'
      else
        flash[:danger] = "Error: #{est.errors.full_messages.to_sentence}."
      end
      redirect_to @usuario

    end

    def set_administrador
      unless a = @usuario.administrador
        a = Administrador.new
        a.usuario_id = @usuario.id
      end

      a.rol = params[:administrador][:rol]

      if params[:administrador][:rol].eql? "admin_departamento"
        a.departamento_id = params[:administrador][:departamento_id] 
        a.escuela_id = nil
      elsif params[:administrador][:rol].eql? "admin_escuela"
        a.escuela_id = params[:administrador][:escuela_id]
        a.departamento_id = nil
      else
        a.departamento_id = nil
        a.escuela_id = nil
      end

      if a.save
        flash[:success] = 'Administrador guardado con éxito'
      else
        flash[:danger] = "Error: #{a.errors.full_messages.to_sentence}."
      end
      redirect_to @usuario

    end

    def delete_rol
      if params[:estudiante]
        u = Estudiante.find params[:id]
      elsif params[:profesor]
        u = Profesor.find  params[:id]
      elsif params[:administrador]
        u = Administrador.find params[:id]
      else
        flash[:danger] = "Error: Rol no encontrado."
      end
      if u
        flash[:info] = "Rol Eliminado." if u.destroy 
      end
      redirect_back fallback_location: principal_admin_index_path
        
    end

    def set_profesor

      if pr = @usuario.profesor
      else
        pr = Profesor.new
        pr.usuario_id = @usuario.id
      end

      pr.departamento_id = params[:profesor][:departamento_id]
      if pr.save
        flash[:success] = 'Profesor guardado con éxito'
      else
        flash[:danger] = "Error: #{a.errors.full_messages.to_sentence}."
      end
      redirect_to @usuario

    end

    def resetear_contrasena
      @usuario.password = @usuario.ci
      
      if @usuario.save
        flash[:success] = "Contraseña reseteada corréctamente"
      else
        flash[:error] = "no se pudo resetear la contraseña"
      end
      redirect_to @usuario
      
    end

    def cambiar_ci
      @usuario.id = params[:cedula]
      if @usuario.save
        if params[:cedula].eql? session[:administrador_id]
          session[:administrador_id] = session[:usuario_ci] = @usuario.id
        end

        flash[:success] = "Cambio de cédula de identidad correcto."
      else
        flash[:error] = "Error excepcional: #{@usuario.errors.full_messages.to_sentence}."
        @usuario = Usuario.find(params[:id])
      end
      redirect_to @usuario
    end

    # GET /usuarios/1
    # GET /usuarios/1.json
    def show
      est = @usuario.estudiante
      @estudiante = est
      @profesor = @usuario.profesor
      @administrador = @usuario.administrador

      @periodos = @estudiante.escuela.periodos.order("inicia DESC") if @estudiante

      @inscripciones = @estudiante.inscripcionsecciones if @estudiante

      # @secciones = CalSeccion.where(:cal_periodo_id => cal_semestre_actual_id)

      if est
        @idiomas2 = @idiomas1 = est.escuela.departamentos.reject{|i| i.id.eql? 'EG' or i.id.eql? 'TRA'; }
        @planes = est.escuela.planes
        @periodos = est.escuela.periodos.order('inicia DESC')
      end
      
      @nickname = @usuario.nickname.capitalize
      inactivo = "<span class='label label-warning'>Inactivo</span>" if @estudiante and @estudiante.inactivo? current_periodo.id
      @titulo = "Detalle de Usuario: #{@usuario.descripcion} #{inactivo}"

    end

    # GET /usuarios/new
    def new
      if params[:estudiante]
        @titulo = "Nuevo Estudiante"
      elsif params[:profesor]
        @titulo = "Nuevo Profesor"
      elsif params[:administrador]
        @titulo = "Nuevo Administrador"
      else
        @titulo = "Nuevo Usuario"
      end
      @usuario = Usuario.new
    end

    # GET /usuarios/1/edit
    def edit
      @titulo = "Editar Usuario: #{@usuario.descripcion}"
    end

    # POST /usuarios
    # POST /usuarios.json
    def create
      @usuario = Usuario.new(usuario_params)
      respond_to do |format|
        if @usuario.save
          flash[:success] = 'Usuario creado con éxito.'
          if params[:estudiante_set]
            if e = Estudiante.create(usuario_id: @usuario.id, escuela_id: params[:estudiante][:escuela_id])
              flash[:success] = 'Estudiante creado con éxito.' 
            else
              flash[:danger] = "Error: #{e.errors.full_messages.to_sentence}"
            end
          elsif params[:administrador]
            a = Administrador.new
            a.usuario_id = @usuario.id
            a.rol = params[:administrador][:rol]

            unless params[:administrador][:departamento_id].blank?
              a.departamento_id = params[:administrador][:departamento_id] 
              a.escuela_id = nil
            end
            unless params[:administrador][:escuela_id].blank?
              a.escuela_id = params[:administrador][:escuela_id]
              a.departamento_id = nil
            end

            if a.save
              flash[:success] = 'Administrador creado con éxito.'
            else
              flash[:danger] = "Error: #{a.errors.full_messages.to_sentence}"
            end
          elsif params[:profesor]
            pr = Profesor.new
            pr.usuario_id = @usuario.id
            pr.departamento_id = params[:profesor][:departamento_id]

            if pr.save
              flash[:success] = 'Profesor creado con éxito.'
            else
              flash[:danger] = "Error: #{pr.errors.full_messages.to_sentence}"
            end
          end
              
          format.html { redirect_to @usuario}
          format.json { render :show, status: :created, location: @usuario }
        else
          flash[:danger] = "Error: #{@usuario.errors.full_messages.to_sentence}"
          format.html { redirect_back fallback_location: new_usuario_path }
          format.json { render json: @usuario.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /usuarios/1
    # PATCH/PUT /usuarios/1.json
    def update
      respond_to do |format|
        if current_admin
          if current_admin.maestros?
            url_back = @usuario
          else
            url_back = principal_admin_index_path
          end
        elsif current_usuario.estudiante
          url_back = principal_estudiante_index_path
        elsif current_usuario.profesor
          url_back = principal_profesor_index_path
        end
        if @usuario.update(usuario_params)
          
          flash[:success] = "Usuario actualizado con éxito"
          format.html { redirect_back fallback_location: url_back}
          format.json { render :show, status: :ok, location: @usuario }
        else
          flash[:danger] = "Error: #{@usuario.errors.full_messages.to_sentence}"

          format.html { redirect_to url_back }
          format.json { render json: @usuario.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /usuarios/1
    # DELETE /usuarios/1.json
    def destroy
      @usuario.destroy
      respond_to do |format|
        format.html { redirect_to usuarios_url, notice: 'Usuario eliminado satisfactoriamente.' }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_usuario
        @usuario = Usuario.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def usuario_params
        params.require(:usuario).permit(:ci, :nombres, :apellidos, :email, :telefono_habitacion, :telefono_movil, :password, :sexo, :password_confirmation)
      end
      def administrador_params
        params.require(:administrador).permit(:rol, :departamento_id, :escuela_id)
      end

  end
end