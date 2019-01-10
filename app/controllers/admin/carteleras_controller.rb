module Admin
  class CartelerasController < ApplicationController
    before_action :filtro_logueado
    before_action :filtro_super_admin!

    before_action :set_cartelera, only: [:show, :edit, :update, :destroy, :set_activa, :set_contenido]

    # GET /carteleras
    # GET /carteleras.json
    def set_activa
      @cartelera.activa = !@cartelera.activa
      if @cartelera.save
        flash[:info] = "Cartelera #{@cartelera.activada_valor}"
      else
        flash[:danger] = "Error: #{@cartelera.errors.full_messages.to_sentence}."
      end
      redirect_to carteleras_path
    end

    def index
      @titulo = "Cartelera"
      @carteleras = Cartelera.all
    end

    # GET /carteleras/1
    # GET /carteleras/1.json
    def show
      @titulo = "Vista previa de la Cartelera"
    end

    # GET /carteleras/new
    def new
      @titulo = "Nueva Cartelera"
      @cartelera = Cartelera.new
    end

    # GET /carteleras/1/edit
    def edit
      @titulo = "Editando Cartelera"
    end

    # POST /carteleras
    # POST /carteleras.json
    def create
      @cartelera = Cartelera.new(cartelera_params)

      respond_to do |format|
        if @cartelera.save
          format.html { redirect_to carteleras_path, notice: 'Cartelera creada con éxito.' }
          format.json { render :show, status: :created, location: @cartelera }
        else
          format.html { render :new }
          format.json { render json: @cartelera.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /carteleras/1
    # PATCH/PUT /carteleras/1.json
    def update
      respond_to do |format|
        if @cartelera.update(cartelera_params)
          format.html { redirect_to carteleras_path, notice: 'Cartelera actualizada con éxito.' }
          format.json { render :show, status: :ok, location: @cartelera }
        else
          format.html { render :edit }
          format.json { render json: @cartelera.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /carteleras/1
    # DELETE /carteleras/1.json
    def destroy
      @cartelera.destroy
      respond_to do |format|
        format.html { redirect_to carteleras_url, notice: 'Cartelera eliminada satisfactoriamente.' }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_cartelera
        @cartelera = Cartelera.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def cartelera_params
        params.require(:cartelera).permit(:contenido, :activa, :text)
      end
  end
end