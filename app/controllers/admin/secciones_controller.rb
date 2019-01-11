module Admin
  class SeccionesController < ApplicationController
    before_action :filtro_logueado
    before_action :filtro_admin_profe
    before_action :filtro_administrador, except: [:index]
    before_action :filtro_admin_puede_escribir
    before_action :set_seccion, except: [:index, :new, :create]

    # GET /secciones
    # GET /secciones.json
    def index
      @secciones = Seccion.all
    end

    def cambiar_capacidad
      @seccion.capacidad = params[:capacidad]
      @seccion.save
    end

    def agregar_profesor_secundario
      unless @seccion.nil?
        if @seccion.secciones_profesores_secundarios.create(profesor_id: params[:profesor_id])
          flash[:success] = "Profesor Secundario agregado a la Asignatura: #{@seccion.descripcion}"
        else
          flash[:error] = "No se pudo agregar la Asignatura"
          render action: 'seleccionar_profesor_secundario'
        end

      else
        flash[:error] = "Sección no encontrada"
        render action: 'seleccionar_profesor_secundario'
      end

      redirect_to principal_admin_index_path

    end

    def seleccionar_profesor
      @accion = params[:sec] ? 'agregar_profesor_secundario' : 'cambiar_profe_seccion'
      @profesores = Profesor.all.sort_by{|profe| profe.usuario.apellidos}
      @titulo = "Cambio de profesor de sección"
    end

    def cambiar_profe_seccion
      @seccion.profesor_id = params[:profesor_id]
      if @seccion.save
        flash[:success] = "Cambio realizado con éxito"
      else
        flash[:error] = "no se pudo guardar los cambios"
      end
      redirect_to principal_admin_index_path
    end

    def desasignar_profesor_secundario
      sps = SeccionProfesorSecundario.where(seccion_id: @seccion.id, profesor_id: params[:profesor_id])

      unless sps.nil?
        flash[:info] =  sps.destroy_all ? "Profesor Desasignado satisfactoriamente." : "No se pudo desasignar al profesor"
      else
        flash[:error] = "Profesor No Encontrado, por favor revisar su solicitud."
      end

      redirect_to principal_admin_index_path
    end

    # GET /secciones/1
    # GET /secciones/1.json
    def show
    end

    # GET /secciones/new
    def new
      @seccion = Seccion.new
    end

    # GET /secciones/1/edit
    def edit
    end

    # POST /secciones
    # POST /secciones.json
    def create
      seccion_params.delete('profesor_id') 
      @seccion = Seccion.new(seccion_params)
      @seccion.profesor_id = nil if seccion_params[:profesor_id].blank?

      respond_to do |format|
        if @seccion.save
          flash[:success] = 'Sección creada con éxito'
          format.html { redirect_back fallback_location: principal_admin_index_path }
          format.json { render :show, status: :created, location: @seccion }
        else
          flash[:danger] = "Error al intentar generar la sección: #{@seccion.errors.full_messages.to_sentence}."
          format.html { redirect_back fallback_location: principal_admin_index_path }
          format.json { render json: @seccion.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /secciones/1
    # PATCH/PUT /secciones/1.json
    def update
      if @seccion.update(seccion_params)
        flash[:success] = 'Sección actualizada con éxito.'
      else
        flash[:danger] = "Error al intentar actualizar la sección: #{@seccion.errors.full_messages.to_sentence}."
      end
      redirect_back fallback_location: principal_admin_index_path
    end

    # DELETE /secciones/1
    # DELETE /secciones/1.json
    def destroy
      @seccion.destroy
      respond_to do |format|
      
        format.html { redirect_back fallback_location: principal_admin_index_path, notice: 'Seccion Eliminada.' }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_seccion
        @seccion = Seccion.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def seccion_params
        params.require(:seccion).permit(:numero, :asignatura_id, :periodo_id, :profesor_id, :calificada, :capacidad, :tipo_seccion_id)
      end
  end
end