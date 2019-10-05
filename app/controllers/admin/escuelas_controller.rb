module Admin
  class EscuelasController < ApplicationController
    # Privilegios
    before_action :filtro_logueado
    before_action :filtro_super_admin!, except: [:destroy, :periodos]
    before_action :filtro_ninja!, only: [:destroy]

    before_action :set_escuela, only: [:show, :edit, :update, :destroy, :periodos, :set_inscripcion_abierta, :clonar_programacion]

    # GET /escuelas
    # GET /escuelas.json
    def periodos
      render json: {ids: @escuela.periodos.where("periodos.id != ?", params[:periodo_actual_id]).order(inicia: :desc).ids.to_a}
    end


    def clonar_programacion
      
      periodo_anterior = @escuela.periodo_anterior current_periodo.id
      errores_programaciones = []
      errores_secciones = []
      total_secciones = periodo_anterior.secciones.count
      total_programaciones = periodo_anterior.programaciones.count

      @escuela.secciones.del_periodo(periodo_anterior.id).each do |se|
        begin
          Seccion.create(numero: se.numero, asignatura_id: se.asignatura_id, periodo_id: current_periodo.id, profesor_id: se.profesor_id, capacidad: se.capacidad, tipo_seccion_id: se.tipo_seccion_id)
        rescue Exception => e
          errores_secciones << "#{se.asignatura_id} - #{se.numero}"
        end
      end

      periodo_anterior.programaciones.each do |pr|
        begin
          Programacion.create(periodo_id: current_periodo.id, asignatura_id: pr.asignatura_id)
        rescue Exception => e
          errores_programaciones << pr.asignatura_id
        end
      end

      flash[:success] = "Migración con éxito de un total de #{total_secciones - errores_secciones.count} secciones."
      
      flash[:danger] = "Las siguientes #{errores_secciones.count} seccines ya existen en el periodo actual: #{errores_secciones.to_sencence}" if errores_secciones.any?
      
      flash[:info] = "Las siguientes #{errores_programaciones.count} asignaturas ya estaban activas en el periodo actual" if errores_programaciones.any?

      redirect_back fallback_location: asignaturas_path

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

    def set_inscripcion_abierta
      @escuela.inscripcion_abierta = !@escuela.inscripcion_abierta
        respond_to do |format|
          if @escuela.save
            format.json { head :ok }
          else
            format.json { head :error }
          end
        end
      
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_escuela
        @escuela = Escuela.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def escuela_params
        params.require(:escuela).permit(:descripcion, :id, :inscripcion_abierta)
      end
  end
end