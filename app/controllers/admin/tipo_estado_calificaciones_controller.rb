module Admin
  class TipoEstadoCalificacionesController < ApplicationController
    before_action :set_tipo_estado_calificacion, only: [:show, :edit, :update, :destroy]

    # GET /tipo_estado_calificaciones
    # GET /tipo_estado_calificaciones.json
    def index
      @tipo_estado_calificaciones = TipoEstadoCalificacion.all
    end

    # GET /tipo_estado_calificaciones/1
    # GET /tipo_estado_calificaciones/1.json
    def show
    end

    # GET /tipo_estado_calificaciones/new
    def new
      @tipo_estado_calificacion = TipoEstadoCalificacion.new
    end

    # GET /tipo_estado_calificaciones/1/edit
    def edit
    end

    # POST /tipo_estado_calificaciones
    # POST /tipo_estado_calificaciones.json
    def create
      @tipo_estado_calificacion = TipoEstadoCalificacion.new(tipo_estado_calificacion_params)

      respond_to do |format|
        if @tipo_estado_calificacion.save
          format.html { redirect_to @tipo_estado_calificacion, notice: 'Tipo estado calificacion was successfully created.' }
          format.json { render :show, status: :created, location: @tipo_estado_calificacion }
        else
          format.html { render :new }
          format.json { render json: @tipo_estado_calificacion.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /tipo_estado_calificaciones/1
    # PATCH/PUT /tipo_estado_calificaciones/1.json
    def update
      respond_to do |format|
        if @tipo_estado_calificacion.update(tipo_estado_calificacion_params)
          format.html { redirect_to @tipo_estado_calificacion, notice: 'Tipo estado calificacion was successfully updated.' }
          format.json { render :show, status: :ok, location: @tipo_estado_calificacion }
        else
          format.html { render :edit }
          format.json { render json: @tipo_estado_calificacion.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /tipo_estado_calificaciones/1
    # DELETE /tipo_estado_calificaciones/1.json
    def destroy
      @tipo_estado_calificacion.destroy
      respond_to do |format|
        format.html { redirect_to tipo_estado_calificaciones_url, notice: 'Tipo estado calificacion was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_tipo_estado_calificacion
        @tipo_estado_calificacion = TipoEstadoCalificacion.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def tipo_estado_calificacion_params
        params.require(:tipo_estado_calificacion).permit(:descripcion, :id)
      end
  end
end