module Admin
  class CombinacionesController < ApplicationController
    before_action :filtro_logueado
    before_action :filtro_administrador
    
    before_action :filtro_autorizado#, only: [:create, :destroy]
    before_action :set_combinacion, only: [:show, :edit, :update, :destroy]

    def index
      @combinaciones = Combinacion.all

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @combinaciones }
      end
    end

    # GET /combinaciones/1
    # GET /combinaciones/1.json
    def show
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @combinacion }
      end
    end

    # GET /combinaciones/new
    # GET /combinaciones/new.json
    def new
      @combinacion = Combinacion.new

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @combinacion }
      end
    end

    # GET /combinaciones/1/edit
    def edit
    end

    # POST /combinaciones
    # POST /combinaciones.json
    def create
      @combinacion = Combinacion.new(combinacion_params)
      if @combinacion.save
        info_bitacora_crud Bitacora::CREACION, @combinacion
        flash[:success] = "Combinación de idiomas agregada exitosamente."
      else
        flash[:error] = "#{@combinacion.errors.full_messages.join(' ')}"
      end
      redirect_back fallback_location: usuario_path(@combinacion.estudiante)
    end

    # PUT /combinaciones/1
    # PUT /combinaciones/1.json
    def update

      if @combinacion.update_attributes(combinacion_params)
        info_bitacora_crud Bitacora::ACTUALIZACION, @combinacion
        flash[:success] = "Combinación de idiomas actualizada con éxito."
      else
        flash[:error] = "#{@combinacion.errors.full_messages.join(' ')}"
      end
      redirect_back fallback_location: usuario_path(@combinacion.estudiante)
    end

    # DELETE /combinaciones/1
    # DELETE /combinaciones/1.json
    def destroy
      id = @combinacion.estudiante_id
      info_bitacora_crud Bitacora::ELIMINACION, @combinacion
      @combinacion.destroy
      flash[:info] = "Combinación de idiomas eliminada satisfactoriamente."
      redirect_to usuario_path(id)
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_combinacion
        @combinacion = Combinacion.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def combinacion_params
        params.require(:combinacion).permit(:id, :estudiante_id, :periodo_id, :idioma1_id, :idioma2_id)
      end

  end

end
