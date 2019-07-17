module Admin
  class GradosController < ApplicationController
    # Privilegios
    before_action :filtro_logueado
    before_action :filtro_administrador

    def index
      escuelas_ids = current_admin.escuelas.ids

      @grados = Inscripcionseccion.grados.del_periodo(current_periodo.id).de_las_escuelas(escuelas_ids)

      @tesistas = @grados.sin_calificar
      @graduandos = @grados.aprobados
    end
  end
end