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
          info_bitacora "Estudiante Vinculado al plan #{@historialplan.plan_id}", Bitacora::ACTUALIZACION, @historialplan.estudiante
          flash[:success] = 'Plan de Estudio Agregado.'
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
        info_bitacora "Cambio de plan de #{anterior} a #{@historialplan.plan_id}", Bitacora::ACTUALIZACION, @historialplan.estudiante
        flash[:success] = 'Historial de Planes de Estudios actualizado con éxito.'
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
      @historialplan.destroy
      info_bitacora "Estudiante Desvinculado al plan #{@historialplan.plan_id}", Bitacora::ELIMINACION, @historialplan.estudiante

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
      params.require(:historialplan).permit(:estudiante_id, :plan_id, :periodo_id)
    end


  end
end