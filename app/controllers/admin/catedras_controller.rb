module Admin
  class CatedrasController < ApplicationController
    # Privilegios
    before_action :filtro_logueado
    # before_action :filtro_admin_mas_altos!, except: [:destroy]
    # before_action :filtro_ninja!, only: [:destroy]
    before_action :filrto_administrador
    before_action :filtro_autorizado, except: [:new, :edit]

    before_action :set_catedra, only: [:show, :edit, :update, :destroy]

    # GET /catedras
    # GET /catedras.json
    def index
      @titulo = "Cátedras"
      @catedras = current_admin.catedras #Catedra.all
    end

    # GET /catedras/1
    # GET /catedras/1.json
    def show
      @titulo = "Detalle: #{@catedra.descripcion}"      
    end

    # GET /catedras/new
    def new
      @titulo = "Nueva Cátedra"
      @catedra = Catedra.new
    end

    # GET /catedras/1/edit
    def edit
      @titulo = "Editando Cátedra: #{@catedra.descripcion}"
    end

    # POST /catedras
    # POST /catedras.json
    def create
      @catedra = Catedra.new(catedra_params)

      respond_to do |format|
        if @catedra.save
          info_bitacora_crud Bitacora::CREACION, @catedra
          format.html { redirect_to @catedra, notice: 'Catedra creada con éxito.' }
          format.json { render :show, status: :created, location: @catedra }
        else
          flash[:danger] = "Error #{@catedra.errors.messages.to_s}"
          format.html { render :new}
          format.json { render json: @catedra.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /catedras/1
    # PATCH/PUT /catedras/1.json
    def update
      respond_to do |format|
        if @catedra.update(catedra_params)
          info_bitacora_crud Bitacora::ACTUALIZACION, @catedra
          format.html { redirect_to @catedra, notice: 'Catedra actualizada con éxito.' }
          format.json { render :show, status: :ok, location: @catedra }
        else
          format.html { render :edit }
          format.json { render json: @catedra.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /catedras/1
    # DELETE /catedras/1.json
    def destroy

      if @catedra.inscripcionsecciones.any?
        flash[:danger] = "La cátedra posee estudiantes inscritos. Por favor elimínelos e inténtelo nuevamente."
      else
        info_bitacora_crud Bitacora::ELIMINACION, @catedra
        @catedra.destroy
      end

      respond_to do |format|
        format.html { redirect_to catedras_url, notice: 'Catedra eliminada.' }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_catedra
        @catedra = Catedra.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def catedra_params
        params.require(:catedra).permit(:descripcion, :id, :orden)
      end
  end
end