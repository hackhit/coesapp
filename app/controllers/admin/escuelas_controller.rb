module Admin
  class EscuelasController < ApplicationController
    # Privilegios
    before_action :filtro_logueado
    before_action :filtro_super_admin!, except: [:destroy]
    before_action :filtro_ninja!, only: [:destroy]

    before_action :set_escuela, only: [:show, :edit, :update, :destroy]

    # GET /escuelas
    # GET /escuelas.json
    def eliminar_escuelaestudiante
      escuela_id, estudiante_id = params[:id].split("/")
      escuela = Escuela.find escuela_id
      usuario = Usuario.find estudiante_id
      p escuela.descripcion.center(200, "#")

      ee = Escuelaestudiante.where(escuela_id: escuela_id, estudiante_id: estudiante_id)
      inscripciones = ee.first.inscripciones
      total = 0
      if params[:escuela_destino_id] and inscripciones.any?
        inscripciones.each do |inscrip|
          inscrip.pci_escuela_id = params[:escuela_destino_id]
          total += 1 if inscrip.save
        end
      end

      info_bitacora_crud Bitacora::ELIMINACION, ee.first
      if ee.delete_all
        flash[:info] = '¡Escuela Eliminada con éxito!'
        flash[:info] += " Se transfirieró un total de #{total} asignatura(s) como pci a la escuela de #{escuela.descripcion}"
      else
        flash[:danger] = 'No se pudo pudo eliminar la escuela. Por favor, inténtelo de nuevo.'
      end
      redirect_back fallback_location: usuario

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