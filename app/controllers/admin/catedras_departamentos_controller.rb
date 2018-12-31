module Admin
  class CatedrasDepartamentosController < ApplicationController
    before_action :set_catedra_departamento, only: [:show, :edit, :update, :destroy]

    # GET /admin/catedras_departamento
    # GET /admin/catedras_departamento.json
    def index
      #@catedras_departamentos = CatedraDepartamento.all 
    end

    # GET /admin/catedras_departamento/1
    # GET /admin/catedras_departamento/1.json
    def show
    end

    # GET /admin/catedras_departamento/new
    def new
      @catedra_departamento = CatedraDepartamento.new
    end

    # GET /admin/catedras_departamento/1/edit
    def edit
    end

    # POST /admin/catedras_departamento
    # POST /admin/catedras_departamento.json
    def create
      @catedra_departamento = CatedraDepartamento.new(catedra_departamento_params)

      respond_to do |format|
        if @catedra_departamento.save
          format.html { redirect_back fallback_location: departamentos_path, success: 'Cátedra y departamento enlazados con éxito.'}
          format.json { render :show, status: :created, location: @catedra_departamento }
        else
          format.html { redirect_back fallback_location: departamentos_path, success: "Error al intentar asociar la cátedra al departamento: #{@catedra_departamento.errors.full_messages.to_sentence}." } 
          format.json { render json: @catedra_departamento.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /admin/catedras_departamento/1
    # PATCH/PUT /admin/catedras_departamento/1.json
    def update
      respond_to do |format|
        if @catedra_departamento.update(catedra_departamento_params)
          format.html { redirect_to @catedra_departamento, notice: 'Catedra actualizadda con éxito.' }
          format.json { render :show, status: :ok, location: @catedra_departamento }
        else
          format.html { render :edit }
          format.json { render json: @catedra_departamento.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /admin/catedras_departamento/1
    # DELETE /admin/catedras_departamento/1.json
    def destroy
      @catedra_departamento.destroy
      respond_to do |format|
        format.html { redirect_back fallback_location: departamentos_path, notice: 'Relación cátedra departamento eliminada.'}
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_catedra_departamento
        @catedra_departamento = CatedraDepartamento.find params[:id]
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def catedra_departamento_params
        params.require(:catedra_departamento).permit(:catedra_id, :departamento_id, :orden)
      end
  end
end