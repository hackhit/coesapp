module Admin
  class TipoasignaturasController < ApplicationController

    before_action :filtro_super_admin!, except: [:destroy]
    before_action :filtro_ninja!, only: [:destroy]

    before_action :set_tipoasignatura, only: [:show, :edit, :update, :destroy]

    # GET /tipoasignaturas
    # GET /tipoasignaturas.json
    def index
      @tipoasignaturas = Tipoasignatura.all
    end

    # GET /tipoasignaturas/1
    # GET /tipoasignaturas/1.json
    def show
    end

    # GET /tipoasignaturas/new
    def new
      @tipoasignatura = Tipoasignatura.new
    end

    # GET /tipoasignaturas/1/edit
    def edit
    end

    # POST /tipoasignaturas
    # POST /tipoasignaturas.json
    def create
      @tipoasignatura = Tipoasignatura.new(tipoasignatura_params)

      respond_to do |format|
        if @tipoasignatura.save
          format.html { redirect_to @tipoasignatura, notice: 'Tipo asignatura creada con éxito.' }
          format.json { render :show, status: :created, location: @tipoasignatura }
        else
          format.html { render :new }
          format.json { render json: @tipoasignatura.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /tipoasignaturas/1
    # PATCH/PUT /tipoasignaturas/1.json
    def update
      respond_to do |format|
        if @tipoasignatura.update(tipoasignatura_params)
          format.html { redirect_to @tipoasignatura, notice: 'Tipo asignatura editada con éxito.' }
          format.json { render :show, status: :ok, location: @tipoasignatura }
        else
          format.html { render :edit }
          format.json { render json: @tipoasignatura.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /tipoasignaturas/1
    # DELETE /tipoasignaturas/1.json
    def destroy
      @tipoasignatura.destroy
      respond_to do |format|
        format.html { redirect_to tipoasignaturas_url, notice: 'Tipo asignatura eliminada satisfactoriamente.' }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_tipoasignatura
        @tipoasignatura = Tipoasignatura.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def tipoasignatura_params
        params.require(:tipoasignatura).permit(:descripcion, :id)
      end
  end
end