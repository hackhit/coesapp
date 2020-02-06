module Admin
  class RestringidasController < ApplicationController
    before_action :filtro_logueado
    before_action :filtro_admin_altos!
    before_action :set_restringida, only: [:show, :edit, :update, :destroy]

    # GET /restringidas
    # GET /restringidas.json

    def lista_de_controllers
       dirs = Dir.new("#{Rails.root}/app/controllers/admin").entries.reject{|c| !(c.include? "_controller.rb")}.collect{|c| c.remove("_controller.rb")}

       seleccionada = dirs.first

       Catedra.new.action_methods

    end

    def index
      @restringidas = Restringida.all
      @titulo = 'Procesos de Acceso Restringidos'
    end

    # GET /restringidas/1
    # GET /restringidas/1.json
    def show
    end

    # GET /restringidas/new
    def new
      @restringida = Restringida.new
      @controladores = Dir.new("#{Rails.root}/app/controllers/admin").entries.reject{|c| !(c.include? "_controller.rb")}.collect{|c| c.remove("_controller.rb").camelize}
      @titulo = 'Nuevo Proceso de Acceso Restringido'
    end

    # GET /restringidas/1/edit
    def edit
      @titulo = 'Editar Proceso de Acceso Restringido'
      @controladores = Dir.new("#{Rails.root}/app/controllers/admin").entries.reject{|c| !(c.include? "_controller.rb")}.collect{|c| c.remove("_controller.rb").camelize}
    end

    # POST /restringidas
    # POST /restringidas.json
    def create
      @restringida = Restringida.new(restringida_params)

      respond_to do |format|
        if @restringida.save
          format.html { redirect_to @restringida, notice: 'Restringida was successfully created.' }
          format.json { render :show, status: :created, location: @restringida }
        else
          format.html { render :new }
          format.json { render json: @restringida.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /restringidas/1
    # PATCH/PUT /restringidas/1.json
    def update
      respond_to do |format|
        if @restringida.update(restringida_params)
          format.html { redirect_to @restringida, notice: 'Restringida was successfully updated.' }
          format.json { render :show, status: :ok, location: @restringida }
        else
          format.html { render :edit }
          format.json { render json: @restringida.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /restringidas/1
    # DELETE /restringidas/1.json
    def destroy
      @restringida.destroy
      respond_to do |format|
        format.html { redirect_to restringidas_url, notice: 'Restringida was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_restringida
        @restringida = Restringida.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def restringida_params
        params.require(:restringida).permit(:id, :acceso_total, :nombre_publico, :controlador, :accion, :grupo)
      end
  end
end