module Admin
  class InscripcionperiodosController < ApplicationController
    before_action :filtro_logueado
    before_action :filtro_admin_mas_altos!, except: [:destroy]
    before_action :filtro_ninja!, only: [:destroy]

    before_action :set_inscripcionperiodo, only: [:show, :edit, :update, :destroy]

    # GET /inscripcionperiodos
    # GET /inscripcionperiodos.json
    def index
      @inscripcionperiodos = Inscripcionperiodo.all
    end

    # GET /inscripcionperiodos/1
    # GET /inscripcionperiodos/1.json
    def show
    end

    # GET /inscripcionperiodos/new
    def new
      @inscripcionperiodo = Inscripcionperiodo.new
    end

    # GET /inscripcionperiodos/1/edit
    def edit
    end

    # POST /inscripcionperiodos
    # POST /inscripcionperiodos.json
    def create
      @inscripcionperiodo = Inscripcionperiodo.new(inscripcionperiodo_params)

      respond_to do |format|
        if @inscripcionperiodo.save
          format.html { redirect_to @inscripcionperiodo, notice: 'Inscripcionperiodo was successfully created.' }
          format.json { render :show, status: :created, location: @inscripcionperiodo }
        else
          format.html { render :new }
          format.json { render json: @inscripcionperiodo.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /inscripcionperiodos/1
    # PATCH/PUT /inscripcionperiodos/1.json
    def update
      respond_to do |format|
        if @inscripcionperiodo.update(inscripcionperiodo_params)
          format.html { redirect_to @inscripcionperiodo, notice: 'Inscripcionperiodo was successfully updated.' }
          format.json { render :show, status: :ok, location: @inscripcionperiodo }
        else
          format.html { render :edit }
          format.json { render json: @inscripcionperiodo.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /inscripcionperiodos/1
    # DELETE /inscripcionperiodos/1.json
    def destroy
      @inscripcionperiodo.destroy
      respond_to do |format|
        format.html { redirect_to inscripcionperiodos_url, notice: 'Inscripcionperiodo was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_inscripcionperiodo
        @inscripcionperiodo = Inscripcionperiodo.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def inscripcionperiodo_params
        params.require(:inscripcionperiodo).permit(:periodo_id, :estudiante_id, :tipo_estado_inscripcion_id)
      end
  end
end