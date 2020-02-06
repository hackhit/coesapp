module Admin
  class CatedradepartamentosController < ApplicationController
    # Privilegios
    before_action :filtro_logueado

    before_action :filtro_administrador
    # before_action :filtro_admin_mas_altos!, except: [:destroy]
    # before_action :filtro_ninja!, only: [:destroy]

    before_action :set_catedradepartamento, only: [:destroy]

    # POST /admin/catedradepartamentos
    # POST /admin/catedradepartamentos.json
    def create
      @catedradepartamento = Catedradepartamento.new(catedradepartamento_params)

      respond_to do |format|
        if @catedradepartamento.save
          info_bitacora "Vinculación de catedra #{@catedradepartamento.catedra.descripcion} con el departamento", Bitacora::CREACION, @catedradepartamento.departamento
          format.html { redirect_back fallback_location: departamentos_path, success: 'Cátedra y departamento enlazados con éxito.'}
          format.json { render :show, status: :created, location: @catedradepartamento }
        else
          format.html { redirect_back fallback_location: departamentos_path, success: "Error al intentar asociar la cátedra al departamento: #{@catedradepartamento.errors.full_messages.to_sentence}." } 
          format.json { render json: @catedradepartamento.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /admin/catedradepartamentos/1
    # DELETE /admin/catedradepartamentos/1.json
    def destroy
      info_bitacora "Desvinculación de catedra #{@catedradepartamento.catedra.descripcion} con el departamento", Bitacora::CREACION, @catedradepartamento.departamento
      @catedradepartamento.destroy
      respond_to do |format|
        format.html { redirect_back fallback_location: departamentos_path, notice: 'Relación cátedra departamento eliminada.'}
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_catedradepartamento
        @catedradepartamento = Catedradepartamento.find params[:id]
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def catedradepartamento_params
        params.require(:catedradepartamento).permit(:catedra_id, :departamento_id, :orden)
      end
  end
end