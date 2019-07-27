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
      if escuela = current_admin.pertenece_a_escuela
        @secciones = escuela.secciones.joins(:asignatura).del_periodo(current_periodo.id).order('asignaturas.descripcion ASC')
        @profesores = escuela.profesores.joins(:usuario).all.order('usuarios.apellidos')
      else
        @escuelas = current_admin.escuelas
        @secciones = Seccion.joins(:asignatura).del_periodo(current_periodo.id).order('asignaturas.descripcion ASC')#Seccion.all
        @profesores = Profesor.joins(:usuario).all.order('usuarios.apellidos')
      end
    end

    def habilitar_calificar_trim
      if params[:id]
        @secciones = Seccion.where(id: params[:id])
        info_bitacora "Seccion: #{params[:id]} habilitada para calificar trimestral" , Bitacora::ACTUALIZACION, @secciones.first
      else
        @secciones = current_periodo.secciones.trimestrales
        info_bitacora "Secciones del periodo: #{current_periodo.id} habilitadas para calificar trimestral" , Bitacora::ACTUALIZACION
      end
      total = 0
      error = 0
      @secciones.each do |seccion|
        seccion.calificada = false
        seccion.abierta = true

        seccion.inscripcionsecciones.each do |es|

          es.tipo_calificacion_id = TipoCalificacion::PARCIAL
          es.calificacion_posterior = nil
          if es.trimestre2?
            es.estado = :trimestre1
          elsif es.trimestre1?
            es.estado = 'sin_calificar'
          end
          es.save

        end
        if seccion.save
          total += 1
        else
          error += 1
        end
      end
      flash[:info] = "Sin asignaturas por habilitar" if (total == 0)
      flash[:success] = "#{total} asignatura(s) habilitada(s) para calificar" if total > 0  
      flash[:danger] = "#{error} asignatura(s) no pudo(ieron) ser habilitada(s). Favor revise he intentelo nuevamente" if error > 0 

      redirect_to principal_admin_index_path

    end

    def habilitar_calificar

      if params[:id]
        @secciones = Seccion.where(id: params[:id])
        info_bitacora "Seccion: #{params[:id]} habilitada para calificar" , Bitacora::ACTUALIZACION, @secciones.first
      else
        @secciones = current_periodo.secciones.calificadas
        info_bitacora "Secciones del periodo: #{current_periodo.id} habilitada para calificar" , Bitacora::ACTUALIZACION
      end
      total = 0
      error = 0
      @secciones.each do |seccion|
        seccion.calificada = false
        seccion.abierta = true

        seccion.inscripcionsecciones.each do |es|

          es.tipo_calificacion_id = nil
          es.calificacion_posterior = nil
          es.estado = 'sin_calificar' unless es.retirado?
          es.save
        end
        if seccion.save
          total += 1
        else
          error += 1
        end
      end
      flash[:info] = "Sin asignaturas por habilitar" if (total == 0)
      flash[:success] = "#{total} asignatura(s) habilitada(s) para calificar" if total > 0  
      flash[:danger] = "#{error} asignatura(s) no pudo(ieron) ser habilitada(s). Favor revise he intentelo nuevamente" if error > 0 

      if params[:id] and params[:return].eql? 'back'
        redirect_to secciones_path(@secciones.first)
      else
        redirect_to principal_admin_index_path
      end
    end

    def importar_secciones
      data = File.readlines("AlemIV.rtf") #read file into array
      data.map! {|line| line.gsub(/world/, "ruby")} #invoke on each line gsub
      File.open("test2.txt", "a") {|f| f.puts "Nueva Linea: #{data}"} #output data to other file
    end

    def calificar
      @estudiantes = params[:est]
      error = false
      if @estudiantes
        @estudiantes.each_pair do |ci,valores|
          @inscripcionseccion = @seccion.inscripcionsecciones.where(estudiante_id: ci).first
          @valores = valores
          if @seccion.asignatura.absoluta?
            calificar_absoluta
          elsif @valores['pi']
            @inscripcionseccion.tipo_calificacion_id = TipoCalificacion::PI
          elsif @seccion.asignatura.numerica3?
            calificar_numerica3
          elsif @seccion.asignatura.numerica?
            calificar_numerica
          end

          if @inscripcionseccion.save
            info_bitacora "Calificado Estudiante: #{@inscripcionseccion.estudiante.descripcion}, Seccion id: (#{@inscripcionseccion.seccion_id})" , Bitacora::ACTUALIZACION, @inscripcionseccion
          else
            error = true
            flash[:danger] = "No se pudo guardar la calificación: #{@inscripcionseccion.errors.full_messages.to_sentence}."
            break
          end

        end
      end

      unless error

        if @seccion.tiene_trimestres1? or @seccion.tiene_trimestres2?
          aux = @seccion.tiene_trimestres1? ? "Trimestre1" : "Trimestre2"
          flash[:success] = "Calificaciones parciales guardada satisfactoriamente."
          info_bitacora "Sección Calificada (#{aux})" , Bitacora::ACTUALIZACION, @seccion
        else
          @seccion.calificada = true
          @seccion.abierta = false if params[:cerrar]

          if @seccion.save
            flash[:success] = "Calificaciones guardada satisfactoriamente."
            info_bitacora "Sección Calificada" , Bitacora::ACTUALIZACION, @seccion
            if @seccion.cerrada?
              flash[:success] += "Sección Cerrada."
              info_bitacora "Sección Cerrada" , Bitacora::ACTUALIZACION, @seccion
            end
          end
        end
      end

      if current_admin
        redirect_to principal_admin_index_path
      elsif current_profesor
        redirect_to principal_profesor_index_path
      end
    end

    def cambiar_capacidad
      @seccion.capacidad = params[:capacidad]
      @seccion.save
    end

    def agregar_profesor_secundario
      unless @seccion.nil?
        if @seccion.secciones_profesores_secundarios.create(profesor_id: params[:profesor_id])
          sp = @seccion.secciones_profesores_secundarios.where(profesor_id: params[:profesor_id]).first
          flash[:success] = "Profesor Secundario agregado a la Asignatura: #{@seccion.descripcion}"
          info_bitacora "Agregado como profesor secunadario Seccion" , Bitacora::CREACION, sp

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

      if params[:secundario].eql? 'true'
        if @seccion.secciones_profesores_secundarios.create(profesor_id: params[:profesor_id])
          sp = @seccion.secciones_profesores_secundarios.where(profesor_id: params[:profesor_id]).first
          flash[:success] = "Profesor Secundario agregado a la Asignatura: #{@seccion.descripcion}"
          info_bitacora "Agregado como profesor secunadario Seccion" , Bitacora::CREACION, sp
        else
          flash[:error] = "No se pudo agregar la Asignatura"
          render action: 'seleccionar_profesor_secundario'
        end
      else

        respond_to do |format|
          if @seccion.save
            msg = "Profesor principal ci: #{params[:profesor_id]} agregado a seccion: (#{@seccion.id})"
            format.html {
              info_bitacora msg, Bitacora::ACTUALIZACION, @seccion
              flash[:success] = "Cambio realizado con éxito"
              redirect_back fallback_location: principal_admin_index_path
               }
            format.json {render json: true, status: :ok}
          else
            flash[:danger] = "No se pudo guardar el cambio: #{@seccion.errors.full_messages.to_sentence}." 
            format.html { redirect_back fallback_location: principal_admin_index_path }
            format.json { render json: @seccion.errors, status: :unprocessable_entity }
          end
        end
      end
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
      @inscripciones_secciones = @seccion.inscripcionsecciones.sort_by{|h| h.usuario.apellidos}
      @any_outplan = @seccion.inscripcionsecciones.aprobado.reject{|h| h.ultimo_plan}.count > 0

      @titulo = "Sección: #{@seccion.descripcion_escuela} - Período #{@seccion.periodo_id}"

      if @seccion.asignatura.catedra_id.eql? 'IB' or @seccion.asignatura.catedra_id.eql? 'LIN' or @seccion.asignatura.catedra_id.eql? 'LE'
        @p1 = 25 
        @p2 =35
        @p3 = 40
      else
        @p1 = @p2 =30
        @p3 = 40
      end


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
          info_bitacora_crud Bitacora::CREACION, @seccion

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
        info_bitacora_crud Bitacora::ACTUALIZACION, @seccion
      else
        flash[:danger] = "Error al intentar actualizar la sección: #{@seccion.errors.full_messages.to_sentence}."
      end
      redirect_back fallback_location: principal_admin_index_path
    end

    # DELETE /secciones/1
    # DELETE /secciones/1.json
    def destroy
      info_bitacora_crud Bitacora::ELIMINACION, @seccion
      @seccion.destroy
      respond_to do |format|
      
        format.html { redirect_back fallback_location: principal_admin_index_path, notice: 'Seccion Eliminada.' }
        format.json { head :no_content }
      end
    end

    private

      def calificar_numerica3
        @inscripcionseccion.primera_calificacion = @valores[:primera_calificacion] unless @valores[:primera_calificacion].blank?

        @inscripcionseccion.segunda_calificacion = @valores[:segunda_calificacion] unless @valores[:segunda_calificacion].blank?

        @inscripcionseccion.tercera_calificacion = @valores[:tercera_calificacion] unless @valores[:tercera_calificacion].blank?

        if @valores[:calificacion_final]
          @inscripcionseccion.calificacion_final = @valores[:calificacion_final]
          tipo_calificacion_id = TipoCalificacion::FINAL
        else
          tipo_calificacion_id = TipoCalificacion::PARCIAL
        end

        @inscripcionseccion.tipo_calificacion_id = tipo_calificacion_id

        calificacion_posterior

      end

      def calificar_numerica

        @inscripcionseccion.calificacion_final = @valores[:calificacion_final]
        @inscripcionseccion.tipo_calificacion_id = TipoCalificacion::FINAL

        calificacion_posterior

      end

      def calificar_absoluta 
        tipo_calificacion_id = TipoCalificacion::FINAL
        estado = @valores[:calificacion_final].to_i

        @inscripcionseccion.calificacion_posterior = nil 
        @inscripcionseccion.calificacion_final = nil

        @inscripcionseccion.tipo_calificacion_id = tipo_calificacion_id
        @inscripcionseccion.estado = Inscripcionseccion.estados.key estado
      end

      def calificacion_posterior

        @inscripcionseccion.tipo_calificacion_id = TipoCalificacion::DIFERIDO if (@valores[:np] or @valores[:nd])

        if @valores[:calificacion_posterior]
          @inscripcionseccion.tipo_calificacion_id = TipoCalificacion::REPARACION if @valores[:nr]
          @inscripcionseccion.calificacion_posterior = @valores[:calificacion_posterior]
        end
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_seccion
        @seccion = Seccion.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def seccion_params
        params.require(:seccion).permit(:numero, :asignatura_id, :periodo_id, :profesor_id, :calificada, :capacidad, :tipo_seccion_id, :abierta)
      end
  end
end