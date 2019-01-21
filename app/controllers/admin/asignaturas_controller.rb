module Admin
  class AsignaturasController < ApplicationController
    # Privilegios
    before_action :filtro_logueado
    #before_action :filtro_admin_mas_altos!, except: [:destroy]
    #before_action :filtro_ninja!, only: [:destroy]

    before_action :set_asignatura, only: [:show, :edit, :update, :destroy, :set_activa]

    def set_activa
      @asignatura.activa = !@asignatura.activa
      @asignatura.save
      head :no_content
    end
    # GET /asignaturas
    # GET /asignaturas.json
    def index
      @titulo = 'Asignaturas'
      @departamentos = current_admin.departamentos
      @departamentos = Departamento.all unless @departamentos

    end

    # GET /asignaturas/1
    # GET /asignaturas/1.json
    def show
      @titulo = @asignatura.descripcion.titleize
    end

    # GET /asignaturas/new
    def new
      @titulo = 'Nueva Asignatura'
      @asignatura = Asignatura.new
      @departamentos = current_admin.departamentos
      @departamentos = Departamento.all unless @departamentos
    end

    # GET /asignaturas/1/edit
    def edit
      @titulo = "Editando #{@asignatura.descripcion}"
      @departamentos = current_admin.departamentos
      @departamentos = Departamento.all unless @departamentos
    end

    # POST /asignaturas
    # POST /asignaturas.json
    def create
      @asignatura = Asignatura.new(asignatura_params)

      catdep = Catedradepartamento.where(departamento_id: asignatura_params[:departamento_id], catedra_id: asignatura_params[:catedra_id]).limit(1).first
      unless catdep
        flash[:danger] = "No se pudo encontrar la asociación Cátedra-Departamento. Seleccione el departamento y la cátedra apropiadamente o primero agregue la cátedra (+ Cátedra) en la <a class='btn btn-info btn-sm' href='#{departamento_path(asignatura_params[:departamento_id])}'>Asignatura</a> para luego generar las asignaturas respectivas."
        redirect_back fallback_location: asignaturas_path 
      else
        respond_to do |format|
          if @asignatura.save
            format.html { redirect_to @asignatura}
            format.json { render :show, status: :created, location: @asignatura }
          else
            @titulo = 'Nueva Asignatura'
            @departamentos = current_admin.departamentos
            flash[:danger] = "Error al intentar generar la asignatura: #{@asignatura.errors.full_messages.to_sentence}."
            format.html { render :new }
            format.json { render json: @asignatura.errors, status: :unprocessable_entity }
          end
        end
      end
    end



    # PATCH/PUT /asignaturas/1
    # PATCH/PUT /asignaturas/1.json
    def update
      respond_to do |format|
        if @asignatura.update(asignatura_params)
          format.html { redirect_to @asignatura, notice: 'Asignatura actulizada con éxito.' }
          format.json { render :show, status: :ok, location: @asignatura }
        else
          flash[:danger] = "Error al intentar actualizar la asignatura: #{@asignatura.errors.full_messages.to_sentence}."
          @titulo = "Editando #{@asignatura.descripcion}"
          @departamentos = current_admin.departamentos
          format.html { render :edit }
          format.json { render json: @asignatura.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /asignaturas/1
    # DELETE /asignaturas/1.json
    def destroy
      @asignatura.destroy
      respond_to do |format|
        format.html { redirect_to asignaturas_url, notice: 'Asignatura eliminada satisfactoriamente.' }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_asignatura
        @asignatura = Asignatura.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def asignatura_params
        params.require(:asignatura).permit(:id, :descripcion, :catedra_id, :departamento_id, :anno, :orden, :id_uxxi, :creditos, :tipoasignatura_id, :calificacion)
      end
  end
end