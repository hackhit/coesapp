module Admin
  class TipoCalificacionesController < ApplicationController
    before_action :filtro_super_admin!, except: [:destroy]
    before_action :filtro_ninja!, only: [:destroy]

    before_action :set_tipo_calificacion, only: [:show, :edit, :update, :destroy]

    # GET /tipo_calificaciones
    # GET /tipo_calificaciones.json
    def index
      @tipo_calificaciones = TipoCalificacion.all
    end

    # GET /tipo_calificaciones/1
    # GET /tipo_calificaciones/1.json
    def show
    end

    # GET /tipo_calificaciones/new
    def new
      @tipo_calificacion = TipoCalificacion.new
    end

    # GET /tipo_calificaciones/1/edit
    def edit
    end

    # POST /tipo_calificaciones
    # POST /tipo_calificaciones.json
    def create
      @tipo_calificacion = TipoCalificacion.new(tipo_calificacion_params)

      respond_to do |format|
        if @tipo_calificacion.save
          info_bitacora_crud Bitacora::CREACION, @tipo_calificacion

          format.html { redirect_to @tipo_calificacion, notice: 'Tipo estado calificacion creado con éxito.' }
          format.json { render :show, status: :created, location: @tipo_calificacion }
        else
          format.html { render :new, flash: {danger: @tipo_calificacion.errors.full_messages.to_sentence } }
          format.json { render json: @tipo_calificacion.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /tipo_calificaciones/1
    # PATCH/PUT /tipo_calificaciones/1.json
    def update
      respond_to do |format|
        if @tipo_calificacion.update(tipo_calificacion_params)
          info_bitacora_crud Bitacora::ACTUALIZACION, @tipo_calificacion
          format.html { redirect_to @tipo_calificacion, notice: 'Tipo estado calificacion actualizado con éxito.' }
          format.json { render :show, status: :ok, location: @tipo_calificacion }
        else
          format.html { render :edit, flash: {danger: @tipo_calificacion.errors.full_messages.to_sentence} }
          format.json { render json: @tipo_calificacion.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /tipo_calificaciones/1
    # DELETE /tipo_calificaciones/1.json
    def destroy
      info_bitacora_crud Bitacora::ELIMINACION, @tipo_calificacion
      @tipo_calificacion.destroy
      respond_to do |format|
        format.html { redirect_to tipo_calificaciones_url, notice: 'Tipo estado calificacion eliminado con éxito.' }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_tipo_calificacion
        @tipo_calificacion = TipoCalificacion.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def tipo_calificacion_params
        params.require(:tipo_calificacion).permit(:descripcion, :id)
      end
  end
end