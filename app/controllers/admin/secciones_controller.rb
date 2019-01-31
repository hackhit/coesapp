module Admin
  class SeccionesController < ApplicationController
    # Privilegios
    before_action :filtro_logueado
    before_action :filtro_admin_profe, only: [:show]
    before_action :filtro_admin_altos!, only: [:agregar_profesor_secundario, :seleccionar_profesor, :cambiar_profe_seccion, :desasignar_profesor_secundario]
    before_action :filtro_admin_mas_altos!, only: [:cambiar_capacidad, :create, :new, :create, :update]
    #before_action :filtro_ninja!, only: [:destroy, :index]

    before_action :set_seccion, except: [:index, :new, :create, :habilitar_calificar]

    # GET /secciones
    # GET /secciones.json
    def index
      @titulo = "Secciones del Periodo: #{current_periodo.id}"
      @secciones = Seccion.joins(:asignatura).del_periodo(current_periodo.id).order('descripcion ASC')#Seccion.all
    end

    def habilitar_calificar
      if params[:id]
        @secciones = Seccion.where(id: params[:id])
      else
        periodo_actual_id = Periodo.find session[:parametros]['periodo_actual_id']
        @secciones = periodo_actual_id.secciones.calificadas
      end
      total = 0
      error = 0
      @secciones.each do |seccion|
        seccion.calificada = false
        seccion.inscripcionsecciones.each{|es| es.tipo_estado_calificacion_id = 'SC'; es.save}
        if seccion.save
          total += 1
        else
          error += 1
        end
        flash[:info] = "Sin asignaturas por habilitar" if (total == 0)
        flash[:success] = "#{total} asignatura(s) habilitada(s) para calificar" if total > 0  
        flash[:danger] = "#{error} asignatura(s) no pudo(ieron) ser habilitada(s). Favor revise he intentelo nuevamente" if error > 0 
      end

      redirect_to principal_admin_index_path
    end

    def importar_secciones
      data = File.readlines("AlemIV.rtf") #read file into array
      data.map! {|line| line.gsub(/world/, "ruby")} #invoke on each line gsub
      File.open("test2.txt", "a") {|f| f.puts "Nueva Linea: #{data}"} #output data to other file
    end

    def calificar
      @estudiantes = params[:est]
      @estudiantes.each_pair do |ci,valores|
        @inscripcionseccion = @seccion.inscripcionsecciones.where(estudiante_id: ci).limit(1).first
        if valores['pi']
          tipo_estado_calificacion_id = Inscripcionseccion::PI
          valores[:calificacion_final] = 0
        elsif valores['np']
          tipo_estado_calificacion_id = Inscripcionseccion::NOPRESENTO
        else
          if @seccion.asignatura.absoluta?
            tipo_estado_calificacion_id = valores[:calificacion_final]
            valores[:calificacion_final] = 0
          elsif valores[:calificacion_final].to_f >= 10
            tipo_estado_calificacion_id = 'A'
          else
            tipo_estado_calificacion_id = 'AP'
          end
        end
        @inscripcionseccion.tipo_estado_calificacion_id = tipo_estado_calificacion_id
        @inscripcionseccion.calificacion_final = valores[:calificacion_final]

        unless @inscripcionseccion.save
          flash[:danger] = "No se pudo guardar la calificación."
          break
        end

      end
      @seccion.calificada = true
      calificada = @seccion.save

      flash[:success] = "Calificaciones guardada satisfactoriamente." if calificada

      if session[:administrador_id]
        redirect_to principal_admin_index_path
      else
        redirect_to @seccion
      end
    end

    def descargar_notas
      pdf = DocumentosPDF.notas seccion
      unless send_data pdf.render,:filename => "notas_#{seccion.asignatura_id}_#{seccion.numero}.pdf",:type => "application/pdf", :disposition => "attachment"
          flash[:mensaje] = "en estos momentos no se pueden descargar las notas, intentelo luego."
        end
      # redirect_to :action => 'index'      
    end

    def cambiar_capacidad
      @seccion.capacidad = params[:capacidad]
      @seccion.save
    end

    def agregar_profesor_secundario
      unless @seccion.nil?
        if @seccion.secciones_profesores_secundarios.create(profesor_id: params[:profesor_id])
          flash[:success] = "Profesor Secundario agregado a la Asignatura: #{@seccion.descripcion}"
        else
          flash[:error] = "No se pudo agregar la Asignatura"
          render action: 'seleccionar_profesor_secundario'
        end

      else
        flash[:error] = "Sección no encontrada"
        render action: 'seleccionar_profesor_secundario'
      end

      redirect_to principal_admin_index_path

    end

    def seleccionar_profesor
      @accion = params[:sec] ? 'agregar_profesor_secundario' : 'cambiar_profe_seccion'
      @profesores = Profesor.all.sort_by{|profe| profe.usuario.apellidos}
      @titulo = "Cambio de profesor de sección"
    end

    def cambiar_profe_seccion
      @seccion.profesor_id = params[:profesor_id]
      if @seccion.save
        flash[:success] = "Cambio realizado con éxito"
      else
        flash[:error] = "no se pudo guardar los cambios"
      end
      redirect_to principal_admin_index_path
    end

    def desasignar_profesor_secundario
      sps = SeccionProfesorSecundario.where(seccion_id: @seccion.id, profesor_id: params[:profesor_id])

      unless sps.nil?
        flash[:info] =  sps.destroy_all ? "Profesor Desasignado satisfactoriamente." : "No se pudo desasignar al profesor"
      else
        flash[:error] = "Profesor No Encontrado, por favor revisar su solicitud."
      end

      redirect_to principal_admin_index_path
    end

    # GET /secciones/1
    # GET /secciones/1.json
    def show
      @inscripciones_secciones = @seccion.inscripcionsecciones.sort_by{|h| h.estudiante.usuario.apellidos}

      @titulo = "Sección: #{@seccion.descripcion} - Período #{@seccion.periodo_id}"

      @secundaria = true if params[:secundaria]
    end

    # GET /secciones/new
    def new
      @seccion = Seccion.new
      @titulo = 'Nueva sección'
      if params[:asignatura_id]
        @mat = Asignatura.find params[:asignatura_id]
        @titulo = "Nueva sección en #{@mat.descripcion.titleize}"
        @departamentos = @mat.escuela.departamentos
      end
    end

    # GET /secciones/1/edit
    def edit
    end

    # POST /secciones
    # POST /secciones.json
    def create
      seccion_params.delete('profesor_id') 
      @seccion = Seccion.new(seccion_params)
      @seccion.profesor_id = nil if seccion_params[:profesor_id].blank?

      respond_to do |format|
        if @seccion.save
          flash[:success] = 'Sección creada con éxito'
          format.html {
            if params[:back]
              url = params[:back]
            else
              url = principal_admin_index_path
            end
            redirect_to url
             }
          format.json { render :show, status: :created, location: @seccion }
        else
          flash[:danger] = "Error al intentar generar la sección: #{@seccion.errors.full_messages.to_sentence}."
          format.html { redirect_back fallback_location: principal_admin_index_path }
          format.json { render json: @seccion.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /secciones/1
    # PATCH/PUT /secciones/1.json
    def update
      if @seccion.update(seccion_params)
        flash[:success] = 'Sección actualizada con éxito.'
      else
        flash[:danger] = "Error al intentar actualizar la sección: #{@seccion.errors.full_messages.to_sentence}."
      end
      redirect_back fallback_location: principal_admin_index_path
    end

    # DELETE /secciones/1
    # DELETE /secciones/1.json
    def destroy
      @seccion.destroy
      respond_to do |format|
      
        format.html { redirect_back fallback_location: principal_admin_index_path, notice: 'Seccion Eliminada.' }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_seccion
        @seccion = Seccion.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def seccion_params
        params.require(:seccion).permit(:numero, :asignatura_id, :periodo_id, :profesor_id, :calificada, :capacidad, :tipo_seccion_id)
      end
  end
end