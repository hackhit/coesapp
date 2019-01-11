module Admin
  class EscuelasController < ApplicationController
    # Privilegios
    before_action :filtro_logueado
    before_action :filtro_super_admin!, except: [:destroy]
    before_action :filtro_ninja!, only: [:destroy]

    before_action :set_escuela, only: [:show, :edit, :update, :destroy]

    # GET /escuelas
    # GET /escuelas.json
    def index
      @escuelas = Escuela.all
    end

    # GET /escuelas/1
    # GET /escuelas/1.json
    def show
    end

    # GET /escuelas/new
    def new
      @escuela = Escuela.new
    end

    # GET /escuelas/1/edit
    def edit
    end

    # POST /escuelas
    # POST /escuelas.json
    def create
      @escuela = Escuela.new(escuela_params)

      respond_to do |format|
        if @escuela.save
          format.html { redirect_to @escuela, notice: 'Escuela was successfully created.' }
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
          format.html { redirect_to @escuela, notice: 'Escuela was successfully updated.' }
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
        format.html { redirect_to escuelas_url, notice: 'Escuela was successfully destroyed.' }
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