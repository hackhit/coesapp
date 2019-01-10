module Admin
  class TipoEstadoInscripcionesController < ApplicationController
    before_action :filtro_super_admin!, except: [:destroy]
    before_action :filtro_ninja!, only: [:destroy]

    before_action :set_tipo_estado_inscripcion, only: [:show, :edit, :update, :destroy]

    # GET /tipo_estado_inscripciones
    # GET /tipo_estado_inscripciones.json
    def index
      @tipo_estado_inscripciones = TipoEstadoInscripcion.all
    end

    # GET /tipo_estado_inscripciones/1
    # GET /tipo_estado_inscripciones/1.json
    def show
    end

    # GET /tipo_estado_inscripciones/new
    def new
      @tipo_estado_inscripcion = TipoEstadoInscripcion.new
    end

    # GET /tipo_estado_inscripciones/1/edit
    def edit
    end

    # POST /tipo_estado_inscripciones
    # POST /tipo_estado_inscripciones.json
    def create
      @tipo_estado_inscripcion = TipoEstadoInscripcion.new(tipo_estado_inscripcion_params)

      respond_to do |format|
        if @tipo_estado_inscripcion.save
          format.html { redirect_to @tipo_estado_inscripcion, notice: 'Tipo estado inscripcion was successfully created.' }
          format.json { render :show, status: :created, location: @tipo_estado_inscripcion }
        else
          format.html { render :new }
          format.json { render json: @tipo_estado_inscripcion.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /tipo_estado_inscripciones/1
    # PATCH/PUT /tipo_estado_inscripciones/1.json
    def update
      respond_to do |format|
        if @tipo_estado_inscripcion.update(tipo_estado_inscripcion_params)
          format.html { redirect_to @tipo_estado_inscripcion, notice: 'Tipo estado inscripcion was successfully updated.' }
          format.json { render :show, status: :ok, location: @tipo_estado_inscripcion }
        else
          format.html { render :edit }
          format.json { render json: @tipo_estado_inscripcion.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /tipo_estado_inscripciones/1
    # DELETE /tipo_estado_inscripciones/1.json
    def destroy
      @tipo_estado_inscripcion.destroy
      respond_to do |format|
        format.html { redirect_to tipo_estado_inscripciones_url, notice: 'Tipo estado inscripcion was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_tipo_estado_inscripcion
        @tipo_estado_inscripcion = TipoEstadoInscripcion.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def tipo_estado_inscripcion_params
        params.require(:tipo_estado_inscripcion).permit(:descripcion, :id)
      end
  end
end