module Admin
  class TipoSeccionesController < ApplicationController
    # Privilegios
    before_action :filtro_logueado
    before_action :filtro_ninja!

    before_action :set_tipo_seccion, only: [:show, :edit, :update, :destroy]

    # GET /tipo_secciones
    # GET /tipo_secciones.json
    def index
      @tipo_secciones = TipoSeccion.all
    end

    # GET /tipo_secciones/1
    # GET /tipo_secciones/1.json
    def show
    end

    # GET /tipo_secciones/new
    def new
      @tipo_seccion = TipoSeccion.new
    end

    # GET /tipo_secciones/1/edit
    def edit
    end

    # POST /tipo_secciones
    # POST /tipo_secciones.json
    def create
      @tipo_seccion = TipoSeccion.new(tipo_seccion_params)

      respond_to do |format|
        if @tipo_seccion.save
          format.html { redirect_to @tipo_seccion, notice: 'Tipo seccion was successfully created.' }
          format.json { render :show, status: :created, location: @tipo_seccion }
        else
          format.html { render :new }
          format.json { render json: @tipo_seccion.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /tipo_secciones/1
    # PATCH/PUT /tipo_secciones/1.json
    def update
      respond_to do |format|
        if @tipo_seccion.update(tipo_seccion_params)
          format.html { redirect_to @tipo_seccion, notice: 'Tipo seccion was successfully updated.' }
          format.json { render :show, status: :ok, location: @tipo_seccion }
        else
          format.html { render :edit }
          format.json { render json: @tipo_seccion.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /tipo_secciones/1
    # DELETE /tipo_secciones/1.json
    def destroy
      @tipo_seccion.destroy
      respond_to do |format|
        format.html { redirect_to tipo_secciones_url, notice: 'Tipo seccion was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_tipo_seccion
        @tipo_seccion = TipoSeccion.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def tipo_seccion_params
        params.require(:tipo_seccion).permit(:descripcion, :id)
      end
  end
end