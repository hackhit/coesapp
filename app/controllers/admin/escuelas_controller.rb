module Admin
  class EscuelasController < ApplicationController
    # Privilegios
    before_action :filtro_logueado
    before_action :filtro_super_admin!, except: [:destroy, :periodos]
    before_action :filtro_ninja!, only: [:destroy]

    before_action :set_escuela, only: [:show, :edit, :update, :destroy, :periodos]

    # GET /escuelas
    # GET /escuelas.json
    def periodos
      render json: {ids: @escuela.periodos.where("periodos.id != ?", params[:periodo_actual_id]).order(inicia: :desc).ids.to_a}
    end


    def index
      @titulo = "Escuelas"
      @escuelas = Escuela.all
    end

    # GET /escuelas/1
    # GET /escuelas/1.json
    def show
      @titulo = "Escuela #{@escuela.descripcion.titleize}"
    end

    # GET /escuelas/new
    def new
      @titulo = "Nueva Escuela"
      @escuela = Escuela.new
    end

    # GET /escuelas/1/edit
    def edit
      @titulo = "Editando Escuela: #{@escuela.descripcion}"
    end

    # POST /escuelas
    # POST /escuelas.json
    def create
      @escuela = Escuela.new(escuela_params)

      respond_to do |format|
        if @escuela.save
          
          info_bitacora_crud Bitacora::CREACION, @escuela
          format.html { redirect_to @escuela, notice: 'Escuela creada con éxito.' }
          format.json { render :show, status: :created, location: @escuela }
        else
          format.html { render :new }
          format.json { render json: @escuela.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /escuelas/1
    # PATCH/PUT /escuelas/1.json
    def update
      respond_to do |format|

        if @escuela.update(escuela_params)
          info_bitacora_crud Bitacora::ACTUALIZACION, @escuela
          format.html { redirect_to @escuela, notice: 'Escuela actualizada con éxito.' }
          format.json { render :show, status: :ok, location: @escuela }
        else
          format.html { render :edit }
          format.json { render json: @escuela.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /escuelas/1
    # DELETE /escuelas/1.json
    def destroy
      @escuela.destroy
      respond_to do |format|
        info_bitacora_crud Bitacora::ELIMINACION, @escuela
        format.html { redirect_to escuelas_url, notice: 'Escuela eliminada satisfactoriamente.' }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_escuela
        @escuela = Escuela.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def escuela_params
        params.require(:escuela).permit(:descripcion, :id)
      end
  end
end