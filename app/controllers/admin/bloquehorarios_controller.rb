module Admin
  class BloquehorariosController < ApplicationController
    before_action :filtro_logueado
    before_action :set_bloquehorario, only: [:show, :edit, :update, :destroy]

    # GET /bloquehorarios
    # GET /bloquehorarios.json
    def index
      @bloquehorarios = Bloquehorario.all
    end

    # GET /bloquehorarios/1
    # GET /bloquehorarios/1.json
    def show
    end

    # GET /bloquehorarios/new
    def new
      @bloquehorario = Bloquehorario.new
      @seccion = Seccion.find params[:seccion_id]
      @bloquehorario.seccion_id = @seccion.id
      @bloquehorario.profesor_id = @seccion.profesor_id if @seccion.unico_profesor?
    end

    # GET /bloquehorarios/1/edit
    def edit
    end

    # POST /bloquehorarios
    # POST /bloquehorarios.json
    def create
      # bloques = params[:bloques_ids]
      # errors = 0
      # bloques.each do |bloque|
      
      bloque = Bloquehorario.new(bloquehorario_params)
      
      unless bloque.save
        params[:error] = bloque.errors.full_messages.to_sentence
      end
      return

    end

    # PATCH/PUT /bloquehorarios/1
    # PATCH/PUT /bloquehorarios/1.json
    def update
      respond_to do |format|
        if @bloquehorario.update(bloquehorario_params)
          format.html { redirect_to @bloquehorario, notice: 'Bloquehorario was successfully updated.' }
          format.json { render :show, status: :ok, location: @bloquehorario }
        else
          format.html { render :edit }
          format.json { render json: @bloquehorario.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /bloquehorarios/1
    # DELETE /bloquehorarios/1.json
    def destroy
      @bloquehorario.destroy
      respond_to do |format|
        format.html { redirect_to bloquehorarios_url, notice: 'Bloquehorario was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_bloquehorario
        @bloquehorario = Bloquehorario.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def bloquehorario_params
        params.require(:bloquehorario).permit(:dia, :entrada, :salida, :horario_id, :profesor_id)
      end
  end
end