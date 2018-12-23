class CatedrasController < ApplicationController
  before_action :set_catedra, only: [:show, :edit, :update, :destroy]

  # GET /catedras
  # GET /catedras.json
  def index
    @catedras = Catedra.all
  end

  # GET /catedras/1
  # GET /catedras/1.json
  def show
  end

  # GET /catedras/new
  def new
    @catedra = Catedra.new
  end

  # GET /catedras/1/edit
  def edit
  end

  # POST /catedras
  # POST /catedras.json
  def create
    @catedra = Catedra.new(catedra_params)

    respond_to do |format|
      if @catedra.save
        format.html { redirect_to @catedra, notice: 'Catedra was successfully created.' }
        format.json { render :show, status: :created, location: @catedra }
      else
        format.html { render :new }
        format.json { render json: @catedra.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /catedras/1
  # PATCH/PUT /catedras/1.json
  def update
    respond_to do |format|
      if @catedra.update(catedra_params)
        format.html { redirect_to @catedra, notice: 'Catedra was successfully updated.' }
        format.json { render :show, status: :ok, location: @catedra }
      else
        format.html { render :edit }
        format.json { render json: @catedra.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /catedras/1
  # DELETE /catedras/1.json
  def destroy
    @catedra.destroy
    respond_to do |format|
      format.html { redirect_to catedras_url, notice: 'Catedra was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_catedra
      @catedra = Catedra.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def catedra_params
      params.require(:catedra).permit(:descripcion, :id)
    end
end
