module Admin 
  class PlanesController < ApplicationController
    # Privilegios
    before_action :filtro_logueado
    before_action :filtro_admin_mas_altos!, except: [:destroy]
    before_action :filtro_ninja!, only: [:destroy]

    before_action :set_plan, only: [:show, :edit, :update, :destroy]

    # GET /planes
    # GET /planes.json
    def index
      @titulo = "Planes de Estudio"
      @planes = current_admin.planes#Plan.all

      # respond_to do |format|
      #   format.html { render :index}
        
      #   format.pdf do

      #     pdf = Archivo.hacer_kardex 15573230
      #     send_data pdf.render,
      #       filename: "export.pdf",
      #       type: 'application/pdf',
      #       disposition: 'inline'
      #   end
      # end

    end

    # GET /planes/1
    # GET /planes/1.json
    def show
      @titulo = "Detalle del Plan de Estudio: #{@plan.descripcion_completa}"
    end

    # GET /planes/new
    def new
      @titulo = "Nuevo Plan de Estudio"
      @plan = Plan.new
    end

    # GET /planes/1/edit
    def edit
      @titulo = "Editando Plan de Estudio: #{@plan.descripcion_completa}"
    end

    # POST /planes
    # POST /planes.json
    def create
      @plan = Plan.new(plan_params)

      respond_to do |format|
        if @plan.save
          info_bitacora_crud Bitacora::CREACION, @plan
          format.html { redirect_to @plan, notice: 'Plan creado con éxtio.' }
          format.json { render :show, status: :created, location: @plan }
        else
          flash[:danger] = "Error al intentar crear el plan: #{@plan.errors.full_messages.to_sentence}"

          format.html { render :new }
          format.json { render json: @plan.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /planes/1
    # PATCH/PUT /planes/1.json
    def update
      respond_to do |format|
        if @plan.update(plan_params)
          info_bitacora_crud Bitacora::ACTUALIZACION, @plan
          format.html { redirect_to @plan, notice: 'Plan actualizado con éxito.' }
          format.json { render :show, status: :ok, location: @plan }
        else
          flash[:danger] = "Error al intentar actualizar el plan: #{@plan.errors.full_messages.to_sentence}"
          format.html { render :edit }
          format.json { render json: @plan.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /planes/1
    # DELETE /planes/1.json
    def destroy
      info_bitacora_crud Bitacora::ELIMINACION, @plan
      @plan.destroy
      respond_to do |format|
        format.html { redirect_to planes_url, notice: 'Plan eliminado correctamente.' }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_plan
        @plan = Plan.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def plan_params
        params.require(:plan).permit(:id, :descripcion, :escuela_id, :creditos)
      end
  end
end