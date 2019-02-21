module Admin
  class PeriodosController < ApplicationController
    # Privilegios
    before_action :filtro_logueado
    before_action :filtro_administrador, only: [:index]
    before_action :filtro_super_admin!, except: [:index]
    before_action :filtro_ninja!, only: [:destroy]    

    before_action :set_periodo, only: [:show, :edit, :update, :destroy]

    # GET /periodos
    # GET /periodos.json
    def index
      @titulo = 'Resumen de los Periodos'
      @periodos = Periodo.order('inicia DESC').all
    end

    # GET /periodos/1
    # GET /periodos/1.json
    def show
      @titulo = "Detalle de Periodo: #{@periodo.id}"      
    end

    # GET /periodos/new
    def new
      @titulo = "Nuevo Periodo"
      @periodo = Periodo.new
    end

    # GET /periodos/1/edit
    def edit
      @titulo = "Editando Periodo: #{@periodo.id}"
    end

    # POST /periodos
    # POST /periodos.json
    def create
      @periodo = Periodo.new(periodo_params)

      respond_to do |format|
        if @periodo.save
          info_bitacora_crud Bitacora::CREACION, @periodo
          flash[:success] = flash[:danger] = ''

          params[:escuelas].each do |escuela_id|
            if @periodo.escuelaperiodos.create!(escuela_id: escuela_id)
              flash[:success] += "Escuela #{escuela_id} vinculada al período con éxito. "
              info_bitacora "Escuela con id: #{escuela_id} vinculada al periodo", Bitacora::ACTUALIZACION, @periodo
            else
              flash[:danger] = "Error al intentar vincular escuela con el período. "
            end
          end
          flash[:danger] = nil if flash[:danger].blank?
          flash[:info] = nil if flash[:info].blank?
          format.html { redirect_to @periodo, notice: 'Período creado con éxito.' }
          format.json { render :show, status: :created, location: @periodo }
        else
          flash[:error] = "Error al intentar generar el periodo: #{@periodo.errors.full_messages.to_sentence}."

          format.html { render :new }
          format.json { render json: @periodo.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /periodos/1
    # PATCH/PUT /periodos/1.json
    def update
      # periodo_actual_id = session[:periodo_actual_id]
      flash[:info] = flash[:danger] = ''
      Escuela.all.each do |escuela|
        if params[:escuelas].include? escuela.id
          unless @periodo.escuelas.include? escuela
            if @periodo.escuelaperiodos.create!(escuela_id: escuela.id)
              flash[:info] += "Escuelas #{escuela.descripcion} vinculada con éxito. \n" 
              info_bitacora "Escuela con id: #{escuela.id} VINCULADA al periodo", Bitacora::ACTUALIZACION, @periodo
            else
              flash[:danger] += "No se pudo vincular la escuela #{escuela.descripcion}"
            end
          end
        elsif @periodo.escuelas.include? escuela 
          if escuela.secciones_en_periodo? @periodo.id 
            flash[:danger] += "No se puede excluir la escuela de #{escuela.descripcion} porque tiene asociadas secciones. Por favor, elimine primero toda sección asociada a ésta para el período solicitado."
          else
            flash[:info] += "#{escuela.descripcion} desvinculada del período. " if @periodo.escuelaperiodos.where(escuela_id: escuela.id).first.destroy
            info_bitacora "Escuela con id: #{escuela.id} DESVICULADA al periodo", Bitacora::ACTUALIZACION, @periodo
          end
        end
      end

      respond_to do |format|
        if @periodo.update(periodo_params)
          info_bitacora_crud Bitacora::ACTUALIZACION, @periodo
          flash[:danger] = nil if flash[:danger].blank?
          flash[:info] = nil if flash[:info].blank?
          format.html { redirect_to @periodo, notice: 'Período actualizado con éxito.' }
          format.json { render :show, status: :ok, location: @periodo }
        else
          flash[:error] = "Error al intentar actualizar el período: #{@periodo.errors.full_messages.to_sentence}."
          format.html { render :edit }
          format.json { render json: @periodo.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /periodos/1
    # DELETE /periodos/1.json
    def destroy
      if @periodo.tiene_secciones?
        flash[:danger] = "No es posible eliminar el período ya que aún posee secciones vinculadas. Por favor elimine éstas y acontinuación elimine el período."
        redirect_back fallback_location: periodos_url
      else
        info_bitacora_crud Bitacora::ELIMINACION, @periodo
        if @periodo.id.eql? session['periodo_actual_id']
          session['periodo_actual_id'] = inicial_current_periodo #current_admin.escuela.periodos.order(inicia: :asc).last
        end
        @periodo.destroy
        redirect_to periodos_url, notice: 'Período eliminado satisfactoriamente.' 
        # respond_to do |format|
        #   format.html { }
        #   format.json { head :no_content }
        # end
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_periodo
        @periodo = Periodo.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def periodo_params
        params.require(:periodo).permit(:id, :inicia, :culmina, :tipo)
      end
  end
end