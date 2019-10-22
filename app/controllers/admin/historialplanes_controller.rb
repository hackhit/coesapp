module Admin
  class HistorialplanesController < ApplicationController
    before_action :filtro_logueado
    before_action :filtro_administrador

    before_action :set_historialplan, only: [:show, :edit, :update, :destroy]

    # GET /historialplan/1
    # GET /historialplan/1.json
    def show
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @cal_estudiante_tipo_plan }
      end
    end

    # GET /historialplan/new
    # GET /historialplan/new.json
    def new
      @historialplan = Historialplan.new
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @cal_estudiante_tipo_plan }
      end
    end

    # GET /historialplan/1/edit
    def edit
    end

    # POST /historialplan
    # POST /historialplan.json
    def create
      @historialplan = Historialplan.new(historialplan_params)
      begin
        if @historialplan.save
          grado = @historialplan.grado
          grado.plan_id = @historialplan.plan_id
          flash[:success] = 'Plan de Estudio Agregado.'
          if grado.save
            flash[:success] = 'Plan de estudio agregado a la carrera del estudiante'
            info_bitacora "Estudiante Vinculado al plan #{@historialplan.plan_id}", Bitacora::ACTUALIZACION, @historialplan.estudiante
          else
            flash[:danger] = 'No se puedo actualizar el plan con la carrera'
          end
        else
          flash[:danger] = "#{@historialplan.errors.full_messages.join' | '}"
        end
      rescue Exception => e
          flash[:danger] = "Error Excepcional: #{e}"
      end
      redirect_to @historialplan.estudiante.usuario
    end

    # PUT /historialplan/1
    # PUT /historialplan/1.json
    def update
      anterior = @historialplan.plan_id
      if @historialplan.update(historialplan_params)
        flash[:success] = 'Historial de Planes de Estudios actualizado con éxito.'
        grado = @historialplan.grado
        grado.plan_id = @historialplan.plan_id
        if grado.save
          info_bitacora "Cambio de plan de #{anterior} a #{@historialplan.plan_id}", Bitacora::ACTUALIZACION, @historialplan.estudiante
          flash[:success] = 'Historial de Planes de Estudios actualizado con éxito. Se actualizó el plan de la carrera'
        else
          flash[:danger] = 'Error al intentar actualizar el plan de la carrera. Por favor revise e intente nuevamente.'
        end
      else
        flash[:danger] = "Error al intentar actualizar la sección: #{@seccion.errors.full_messages.to_sentence}."
      end
      redirect_to @historialplan.estudiante.usuario


      # begin
      #   update_ci = true
      #   connection = ActiveRecord::Base.connection()
      #   sql = "UPDATE historiales_planes SET periodo_id='#{est_plan[:periodo_id]}', plan_id='#{est_plan[:plan_id]}' WHERE (estudiante_id='#{ci}') AND (plan_id='#{plan}') AND (periodo_id='#{periodo}');"
      #   connection.execute(sql)        
      # rescue Exception => e
      #   flash[:danger] = "No es posible actualizar el plan. por favor verifique: #{e}"
      # end

      # redirect_to controller: "cal_principal_admin", action: "detalle_usuario", ci: ci

    end

    # DELETE /historialplan/1
    # DELETE /historialplan/1.json
    def destroy
      usuario = @historialplan.estudiante.usuario
      grado = @historialplan.grado

      if @historialplan.destroy
        aux = grado.estudiante.historialplanes.por_escuela(grado.escuela_id).order('periodo_id DESC').first
        grado.plan_id = aux ? aux.plan_id : nil
        if grado.save
          info_bitacora "Estudiante desvinculado del plan #{@historialplan.plan_id}", Bitacora::ELIMINACION, @historialplan.estudiante
        end
      end
      respond_to do |format|
        format.html { redirect_to @historialplan.estudiante.usuario, notice: 'Historial de Plan de Estudio eliminado satisfactoriamente.'}
        format.json { head :ok }
      end
      
    end

    private

    def set_historialplan
      @historialplan = Historialplan.find(params[:id])
    end    

    def historialplan_params
      params.require(:historialplan).permit(:estudiante_id, :plan_id, :periodo_id, :escuela_id)
    end


  end
end