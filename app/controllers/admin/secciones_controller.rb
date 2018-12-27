module Admin
  class SeccionesController < ApplicationController
    before_action :set_seccion, only: [:show, :edit, :update, :destroy]

    # GET /secciones
    # GET /secciones.json
    def index
      @secciones = Seccion.all
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
      @seccion = Seccion.new(seccion_params)

      respond_to do |format|
        if @seccion.save
          format.html { redirect_to @seccion, notice: 'Seccion was successfully created.' }
          format.json { render :show, status: :created, location: @seccion }
        else
          format.html { render :new }
          format.json { render json: @seccion.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /secciones/1
    # PATCH/PUT /secciones/1.json
    def update
      respond_to do |format|
        if @seccion.update(seccion_params)
          format.html { redirect_to @seccion, notice: 'Seccion was successfully updated.' }
          format.json { render :show, status: :ok, location: @seccion }
        else
          format.html { render :edit }
          format.json { render json: @seccion.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /secciones/1
    # DELETE /secciones/1.json
    def destroy
      @seccion.destroy
      respond_to do |format|
        format.html { redirect_to secciones_url, notice: 'Seccion was successfully destroyed.' }
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
        params.require(:seccion).permit(:numero, :asignatura_id, :periodo_id, :profesor_id, :calificada)
      end
  end
end