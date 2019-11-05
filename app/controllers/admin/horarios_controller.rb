module Admin
  class HorariosController < ApplicationController
    before_action :filtro_logueado
    before_action :filtro_administrador
    before_action :set_horario, only: [:show, :edit, :update, :destroy]

    # GET /horarios
    # GET /horarios.json
    def index
      @horarios = Horario.all
    end

    # GET /horarios/1
    # GET /horarios/1.json
    def show
    end

    # GET /horarios/new
    def new
      @horario = Horario.new
      @seccion = Seccion.find params[:seccion_id]
      @horario.seccion_id = @seccion.id
      @titulo = 'Nuevo Horario'
      @profesores = @seccion.todos_profes

    end

    # GET /horarios/1/edit
    def edit
      @seccion = @horario.seccion
      @horario.seccion_id = @seccion.id
      @titulo = 'Editar Horario'
      @profesores = @seccion.todos_profes
    end

    # POST /horarios
    # POST /horarios.json
    def create

      @horario = Horario.new(horario_params)
      unless @horario.save
        flash[:error] = "No fue posible guardar el horario: #{@horario.errors.full_messages.to_sentence}"
        @seccion = @horario.seccion
        @titulo = 'Nuevo Horario'
        @profesores = @seccion.todos_profes
        render :new

      else
        flash[:success] = 'Horario generado con éxito'
        flash[:error] = ""
        bloques = params[:bloques_ids]

        total = params[:bloquehorario][:dias].length-1

        for i in(0..total) 
          profesor_id = params[:bloquehorario][:profesores][i]
          
          dia = params[:bloquehorario][:dias][i]
          dia = Bloquehorario::DIAS[dia.to_i]

          horas = params[:bloquehorario][:horas][i]
          entrada, salida = horas.split(' - ')

          params[:bloquehorario][:horario_id] = @horario.id
          params[:bloquehorario][:dia] = dia
          params[:bloquehorario][:entrada] = entrada
          params[:bloquehorario][:salida] = salida
          params[:bloquehorario][:profesor_id] = profesor_id unless profesor_id.blank?

          # redirect_to bloquehorarios_path
          
          @bloque = Bloquehorario.new(params[:bloquehorario])
          unless @bloque.save
            flash[:error] += @bloque.errors.full_messages.to_sentence
          end
        end
        redirect_to @horario
      end

    end

    # PATCH/PUT /horarios/1
    # PATCH/PUT /horarios/1.json
    def update
      respond_to do |format|
        if @horario.update(horario_params)
          format.html { redirect_to @horario, notice: 'Horario actualizado con éxito.' }
          format.json { render :show, status: :ok, location: @horario }
        else
          format.html { render :edit }
          format.json { render json: @horario.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /horarios/1
    # DELETE /horarios/1.json
    def destroy
      @horario.destroy
      respond_to do |format|
        format.html { redirect_to horarios_url, notice: 'Horario ha sido eliminado.' }
        format.json { head :no_content }
      end
    end

    private

      # def create_bloquehorario
      #   @bloque = Bloquehorario.new(params[:bloquehorario])
      #   @bloque.save
      # end
      # Use callbacks to share common setup or constraints between actions.
      def set_horario
        @horario = Horario.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def horario_params
        params.require(:horario).permit(:seccion_id, :titulo)
      end
  end
end