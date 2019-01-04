module Admin
  class UsuariosController < ApplicationController
    before_action :filtro_logueado
    before_action :filtro_administrador
    # before_action :set_usuario, only: [:show, :edit, :update, :destroy, :cambiar_ci, :resetear_contrasena]
    before_action :set_usuario, except: [:index, :new, :create]


    # GET /usuarios
    # GET /usuarios.json
    # def index
    #   @usuarios = Usuario.all
    # end

    def index
      @titulo = 'Usuarios'
      @admin = current_usuario.administrador

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
        @usuarios = Usuario.limit(50).order("apellidos, nombres, ci")      
      end
    end

    def set_estudiante
      est = Estudiante.new
      est.usuario_id = @usuario.id
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
      a.departamento_id = params[:administrador][:departamento_id] if params[:administrador][:departamento_id]

      if a.save
        flash[:success] = 'Administrador guardado con éxito'
      else
        flash[:danger] = "Error: #{a.errors.full_messages.to_sentence}."
      end
      redirect_to @usuario

    end

    def set_profesor

      unless pr = @usuario.profesor
        pr = Profesor.new
        pr.usuario_id = @usuario.id
      end

      pr.departamento_id = params[:profesor][:departamento_id]
      if pr.save
        flash[:success] = 'Administrador guardado con éxito'
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

      # redirect_back fallback_location: usuario_path(@usuario)
      # begin
      #   cedula = Integer(params[:cedula])
      #   connection = ActiveRecord::Base.connection()
      #   sql = "UPDATE usuarios SET ci = '#{cedula}' where ci = '#{params[:id]}';"
      #   connection.execute(sql)
      #   flash[:success] = "Cambio de cédula de identidad correcto."
      #   redirect_to usuario_path controller: 'cal_principal_admin', action: 'detalle_usuario', ci: cedula

      # rescue Exception => e
      #   flash[:error] = "Error excepcional: #{e}"
      #   redirect_to controller: 'cal_principal_admin', action: 'detalle_usuario', ci: params[:usuario_ci]
      # end


      # begin
      #   cedula = Integer(params[:cedula])
      #   connection = ActiveRecord::Base.connection()
      #   sql = "UPDATE usuarioS set  = '#{cedula}' where ci = '#{params[:usuario_ci]}';"
      #   connection.execute(sql)
      #   flash[:success] = "Cambio de cédula de identidad correcto."
      #   redirect_to controller: 'cal_principal_admin', action: 'detalle_usuario', ci: cedula

      # rescue Exception => e
      #   flash[:error] = "Error excepcional: #{e}"
      #   p " Error ".center(200," !! ")
      #   p "Error excepcional: #{e}".center(200," -- ")
      #   p " Error ".center(200," !! ")
      #   redirect_to controller: 'cal_principal_admin', action: 'detalle_usuario', ci: params[:usuario_ci]
      # end

    end

    # GET /usuarios/1
    # GET /usuarios/1.json
    def show
      @periodo_actual_id = session[:parametros]['periodo_actual_id']

      @estudiante = @usuario.estudiante
      @profesor = @usuario.profesor
      @administrador = @usuario.administrador

      # @secciones_estudiantes = CalEstudianteSeccion.where(:cal_estudiante_ci => @estudiante.cal_usuario_ci)   
      @admin = Administrador.find session[:administrador_id]

      @periodos = Periodo.order("id DESC").all

      @inscripciones = @estudiante.inscripcionsecciones if @estudiante

      # @secciones = CalSeccion.where(:cal_periodo_id => cal_semestre_actual_id)
      @idiomas1 = Departamento.all.reject{|i| i.id.eql? 'EG' or i.id.eql? 'TRA'; }
      @idiomas2 = Departamento.all.reject{|i| i.id.eql? 'EG' or i.id.eql? 'TRA'; }
      @nickname = @estudiante.usuario.nickname.capitalize
      inactivo = "<span class='label label-warning'>Inactivo</span>" if @estudiante and @estudiante.inactivo?
      @titulo = "Detalle de Usuario: #{@usuario.descripcion} #{inactivo}"

    end

    # GET /usuarios/new
    def new
      @titulo = "Nuevo Usuario"
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
            if e = Estudiante.create(usuario_id: @usuario.id)
              flash[:success] = 'Estudiante creado con éxito.' 
            else
              flash[:danger] = "Error: #{e.errors.full_messages.to_sentence}"
            end
          elsif params[:administrador]
            a = Administrador.new
            a.usuario_id = @usuario.id
            a.rol = params[:administrador][:rol]
            a.departamento_id = params[:administrador][:departamento_id] if params[:administrador][:departamento_id]
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
        if @usuario.update(usuario_params)
          format.html { redirect_to @usuario, notice: 'Usuario actualizado con éxito.' }
          format.json { render :show, status: :ok, location: @usuario }
        else
          format.html { render :edit }
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
        params.require(:usuario).permit(:ci, :nombres, :apellidos, :email, :telefono_habitacion, :telefono_movil, :password, :sexo)
      end
      def administrador_params
        params.require(:administrador).permit(:rol)
      end

  end
end