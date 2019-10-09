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
        @usuarios = Usuario.search(params[:term]).limit(10).reject{|u| u.estudiante.nil?} 
      elsif params[:profesores]
        @usuarios = Usuario.search(params[:term]).limit(10).reject{|u| u.profesor.nil?}
      else
        @usuarios = Usuario.search(params[:term]).limit(10)
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
      e = Estudiante.new
      e.usuario_id = @usuario.id
      if e.save
        e.grados.create(escuela_id: params[:estudiante][:escuela_id])
        flash[:success] = 'Estudiante registrado con éxito'
        # OJO: No se puede implementar esto ya que no se tiene información sobre a partir de cuando (PERIODO_ID) es el plan
        # Debería incorporarse al form de set estudiante y al form de create usuario el plan y apartir de cuando

        # escuela = Escuela.find params[:estudiante][:escuela_id]
        # planes = escuela.planes
        # e.historialplanes.create(plan_id: planes.first.id) if planes.count.eql? 1
        info_bitacora_crud Bitacora::CREACION, e
      else
        flash[:danger] = "Error: #{e.errors.full_messages.to_sentence}."
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
        info_bitacora_crud Bitacora::CREACION, a
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
      if u and u.destroy
        flash[:info] = "Rol Eliminado." 
        info_bitacora_crud Bitacora::ELIMINACION, u
      end
      redirect_back fallback_location: principal_admin_index_path
        
    end

    def set_profesor

      if pr = @usuario.profesor
      else
        pr = Profesor.new
        pr.usuario_id = @usuario.id
      end
      
      anterior = pr.departamento if params[:cambiar_dpto]

      pr.departamento_id = params[:profesor][:departamento_id]
      if pr.save
        if params[:cambiar_dpto]
          info_bitacora "Cambio de escuela de #{anterior.descripcion_completa} a #{pr.departamento.descripcion_completa}", Bitacora::CREACION, pr
        else
          info_bitacora_crud Bitacora::CREACION, pr
        end
        flash[:success] = 'Profesor guardado con éxito'
      else
        flash[:danger] = "Error: #{a.errors.full_messages.to_sentence}."
      end
      redirect_to @usuario

    end

    def resetear_contrasena
      @usuario.password = @usuario.ci
      
      if @usuario.save
        info_bitacora 'Reseteo de contraseña', Bitacora::ACTUALIZACION, @usuario
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
        info_bitacora 'Cambio de CI', Bitacora::ACTUALIZACION, @usuario
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
      @estudiante = @usuario.estudiante
      @profesor = @usuario.profesor
      @administrador = @usuario.administrador

      #@periodos = @estudiante.escuela.periodos.order("inicia DESC") if @estudiante

      if @estudiante
        @periodos = Periodo.joins(:inscripcionseccion).where("inscripcionsecciones.estudiante_id = #{@estudiante.id}")
        @inactivo = "<span class='label label-warning'>Inactivo</span>" if @estudiante.inactivo? current_periodo.id
        ids = @estudiante.inscripcionsecciones.select{|ins| ins.pci_pendiente_por_asociar?}.collect{|i| i.id}
        @secciones_pci_pendientes = Inscripcionseccion.where(id: ids)#select{|ins| ins.pci_pendiente_por_asociar?}.ids

      end  

      if @profesor
        @secciones_pendientes = @profesor.secciones.sin_calificar.order('periodo_id DESC, numero ASC')
        @secciones_calificadas = @profesor.secciones.calificadas.order('periodo_id DESC, numero ASC')
        @secciones_secundarias = @profesor.secciones_secundarias.order('periodo_id DESC, numero ASC')
      end
      @nickname = @usuario.nickname.capitalize
      @titulo = "Detalle de Usuario: #{@usuario.descripcion} #{@inactivo}"

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

            if e = Estudiante.create(usuario_id: @usuario.id) #, escuela_id: params[:estudiante][:escuela_id])
              params[:grado]['escuela_id'] = params[:escuela_id]
              params[:grado]['estudiante_id'] = e.id

              if params[:grado]['estado_inscripcion']
                params[:grado]['inscrito_ucv'] = 1
              else
                params[:grado]['inscrito_ucv'] = 0
              end
              grado = Grado.new(grado_params)
              grado.plan_id = params[:plan][:id]
              if grado.save!
                info_bitacora_crud Bitacora::CREACION, e
                historialplan = Historialplan.new
                historialplan.estudiante_id = e.id
                historialplan.periodo_id = current_periodo.id
                historialplan.plan_id = params[:plan][:id]

                if historialplan.save
                  info_bitacora_crud Bitacora::CREACION, historialplan
                  flash[:success] = 'Estudiante creado con éxito.' 
                end
              end

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
              info_bitacora_crud Bitacora::CREACION, a
              flash[:success] = 'Administrador creado con éxito.'
            else
              flash[:danger] = "Error: #{a.errors.full_messages.to_sentence}"
            end
          elsif params[:profesor]
            pr = Profesor.new
            pr.usuario_id = @usuario.id
            pr.departamento_id = params[:profesor][:departamento_id]

            if pr.save
              info_bitacora_crud Bitacora::CREACION, pr
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
          # @usuario.estudiante.direccion.create(direccion_params)
          info_bitacora_crud Bitacora::ACTUALIZACION, @usuario
          
          Direccion.create(direccion_params)

          @usuario.estudiante.discapacidad = params[:estudiante][:discapacidad]
          @usuario.estudiante.titulo_universitario = params[:estudiante][:titulo_universitario]
          @usuario.estudiante.titulo_universidad = params[:estudiante][:universidad_universitario]
          @usuario.estudiante.titulo_anno = params[:estudiante][:anno_universitario]

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
      info_bitacora_crud Bitacora::ELIMINACION, @usuario
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
        params.require(:usuario).permit(:ci, :nombres, :apellidos, :email, :telefono_habitacion, :telefono_movil, :password, :sexo, :password_confirmation, :nacionalidad, :estado_civil, :fecha_nacimiento, :pais_nacimiento, :ciudad_nacimiento)
      end

      def administrador_params
        params.require(:administrador).permit(:rol, :departamento_id, :escuela_id)
      end

      def grado_params
        params.require(:grado).permit(:escuela_id, :estudiante_id, :estado, :culminacion_periodo_id, :tipo_ingreso, :inscrito_ucv, :estado_inscripcion, :iniciado_periodo_id)
      end

      def direccion_params
        params.require(:direccion).permit(:estudiante_id, :estado, :municipio, :ciudad, :sector, :calle, :tipo_vivienda, :numero_vivienda, :nombre_vivienda)
      end

  end
end