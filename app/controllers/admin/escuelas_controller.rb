module Admin
  class EscuelasController < ApplicationController
    # Privilegios
    before_action :filtro_logueado
    before_action :filtro_super_admin!, except: [:destroy, :periodos]
    before_action :filtro_ninja!, only: [:destroy]

    before_action :set_escuela, only: [:show, :edit, :update, :destroy, :periodos, :set_inscripcion_abierta, :clonar_programacion, :limpiar_programacion]

    # GET /escuelas
    # GET /escuelas.json
    def periodos
      render json: {ids: @escuela.periodos.where("periodos.id != ?", params[:periodo_actual_id]).order(inicia: :desc).ids.to_a}
    end

    def limpiar_programacion
      @escuela.asignaturas.each do |asig|
        total = true
        progs = asig.programaciones.del_periodo(current_periodo.id)
        if progs.count > 0
          total = false unless progs.delete_all
        end
      end
      # if Seccion.del_periodo(current_periodo.id).de_la_escuela(@escuela.id).delete_all
      # if Seccion.del_periodo(current_periodo.id).joins(:escuela).where("escuelas.id = ?", 'EDUC').delete_all

      Seccion.del_periodo(current_periodo.id).de_la_escuela(@escuela.id).each do |sec|
        sec.delete
      end
      info_bitacora("Eliminada programación de escuela: #{@escuela.descripcion}. Del período #{current_periodo.id}", 3)
      flash[:info] = "¡Programaciones eliminadas correctamente!"
      redirect_back fallback_location: "#{asignaturas_path}?escuela_id=#{@escuela.id}"
    end

    def clonar_programacion
      periodo_anterior = Periodo.find params[:periodo_id]
      errores_programaciones = []
      errores_secciones = []
      total_secciones = periodo_anterior.secciones.de_la_escuela(@escuela.id).count
      total_programaciones = 0
      programaciones_existentes = 0
      errores_excepcionales = []

      @escuela.secciones.del_periodo(periodo_anterior.id).each do |se|
        principal = params[:profesores] ? se.profesor_id : nil
        begin

          nueva_seccion = Seccion.find_or_initialize_by(numero: se.numero, asignatura_id: se.asignatura_id, periodo_id: current_periodo.id)
          nueva_seccion.profesor_id = principal
          nueva_seccion.capacidad = se.capacidad
          nueva_seccion.tipo_seccion_id = se.tipo_seccion_id
          nueva_seccion.save
        rescue Exception => e
          errores_excepcionales << "Error al crear o buscar sección: #{nueva_seccion.id} #{e}"
        end

        begin
          if params[:profesores]
            se.secciones_profesores_secundarios.each do |secundario|
              SeccionProfesorSecundario.find_or_create_by(profesor_id: secundario.profesor_id, seccion_id: nueva_seccion.id)
            end
          else
            nueva_seccion.secciones_profesores_secundarios.delete_all
          end
        rescue Exception => e
          errores_excepcionales << "Error al intentar agregar profesores secundarios a #{se.descripcion_simple}: #{e} </br></br>"
        end

        begin
          if params[:horarios] and se.horario
            nueva_seccion.horario.delete if nueva_seccion.horario
            Horario.create(seccion_id: nueva_seccion.id, color: se.horario.color)
            se.horario.bloquehorarios.each do |bh|
              bh_aux = Bloquehorario.new(dia: bh.dia, entrada: bh.entrada, salida: bh.salida, horario_id: nueva_seccion.id)
              bh_aux.profesor_id = bh.profesor_id if params[:profesores]
              bh_aux.save
            end
          end
        rescue Exception => e
          errores_excepcionales << "Error al intentar agregar horario a #{seccion_nueva.descripcion_simple}: #{e} </br></br>"
        end

          info_bitacora("Clonación de secciones de la escuela: #{@escuela.descripcion}. Del período #{periodo_anterior.id} al periodo #{current_periodo.id}", 5)
      end

      periodo_anterior.programaciones.de_la_escuela(@escuela.id).each do |pr|
        if progr_aux = Programacion.where(periodo_id: current_periodo.id, asignatura_id: pr.asignatura_id).first
          programaciones_existentes += 1
        else
          progr_aux = Programacion.new(periodo_id: current_periodo.id, asignatura_id: pr.asignatura_id)
          if progr_aux.save
            total_programaciones += 1 
          else
            errores_programaciones << "No se logró activar asignatura #{pr.asignatura_id}: #{progr_aux.errors.full_messages.to_sentence}"   
          end
        end
      end

      flash[:success] = "Clonación con éxito de un total de #{total_secciones - errores_secciones.count} secciones."
      
      flash[:danger] = "<b> Secciones no agregadas #{errores_secciones.count}:</b></br> #{errores_secciones.to_sentence}" if errores_secciones.any?
      flash[:info] = "<b>Información Complementaria:</b>  </br>"

      flash[:info] += "<b></br>Programaciones:</b></br>"
      flash[:info] += "Se activaron #{total_programaciones} asignaturas de un total de #{periodo_anterior.programaciones.de_la_escuela(@escuela.id).count}. "
      flash[:info] += "Estaban ya activas #{programaciones_existentes} asignaturas de un total de #{periodo_anterior.programaciones.de_la_escuela(@escuela.id).count}. "

      flash[:info] += "<b> #{errores_programaciones.count} Programaciones no activadas:</b></br> #{errores_programaciones.to_sentence}" if errores_programaciones.any?

      redirect_back fallback_location: "#{asignaturas_path}?escuela_id=#{@escuela.id}"

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