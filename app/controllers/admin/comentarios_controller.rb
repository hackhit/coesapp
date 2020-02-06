module Admin
  class ComentariosController < ApplicationController
    before_action :set_comentario, only: [:show, :edit, :update, :destroy, :habilitar]
    before_action :filtro_administrador

    before_action :filtro_autorizado, except: [:new, :edit]
    # GET /comentarios
    # GET /comentarios.json

    def habilitar
      @comentario.habilitado = !@comentario.habilitado
      @comentario.save
    end

    def index
      @comentarios = Comentario.order('updated_at DESC').limit(70)
      @titulo = "Noticias y Comentarios"
    end

    # GET /comentarios/1
    # GET /comentarios/1.json
    def show
    end

    # GET /comentarios/new
    def new
      @comentario = Comentario.new
      @titulo = "Nuevo Comentario"
    end

    # GET /comentarios/1/edit
    def edit
      @titulo = "Editando Nota"
    end

    # POST /comentarios
    # POST /comentarios.json
    def create
      @comentario = Comentario.new(comentario_params)

      respond_to do |format|
        if @comentario.save
          format.html { redirect_to @comentario, notice: 'Comentario generado con éxtio.' }
          format.json { render :show, status: :created, location: @comentario }
        else
          format.html { render :new }
          format.json { render json: @comentario.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /comentarios/1
    # PATCH/PUT /comentarios/1.json
    def update
      respond_to do |format|
        if @comentario.update(comentario_params)
          format.html { redirect_to @comentario, notice: 'Comentario actualizado con éxito.' }
          format.json { render :show, status: :ok, location: @comentario }
        else
          format.html { render :edit }
          format.json { render json: @comentario.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /comentarios/1
    # DELETE /comentarios/1.json
    def destroy
      @comentario.destroy
      respond_to do |format|
        format.html { redirect_to comentarios_url, notice: '¡Comentario Eliminado!' }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_comentario
        @comentario = Comentario.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def comentario_params
        params.require(:comentario).permit(:contenido, :estado, :habilitado)
      end
  end
end