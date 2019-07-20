module Admin
  class GradosController < ApplicationController
    # Privilegios
    before_action :filtro_logueado
    before_action :filtro_administrador

    def index
      escuelas_ids = current_admin.escuelas.ids

      @grados = Inscripcionseccion.grados.del_periodo(current_periodo.id).de_las_escuelas(escuelas_ids)

      @tesistas = @grados.sin_calificar
      @graduandos = @grados.aprobado
    end
    # Fin Index

    def eliminar
      escuela_id, estudiante_id = params[:id].split("-")
      escuela = Escuela.find escuela_id
      usuario = Usuario.find estudiante_id
      p escuela.descripcion.center(200, "#")

      ee = Escuelaestudiante.where(escuela_id: escuela_id, estudiante_id: estudiante_id)
      inscripciones = ee.first.inscripciones
      total = 0
      if params[:escuela_destino_id] and inscripciones.any?
        inscripciones.each do |inscrip|
          inscrip.pci_escuela_id = params[:escuela_destino_id]
          total += 1 if inscrip.save
        end
      end

      info_bitacora_crud Bitacora::ELIMINACION, ee.first
      if ee.delete_all
        flash[:info] = '¡Escuela Eliminada con éxito!'
        flash[:info] += " Se transfirieró un total de #{total} asignatura(s) como pci a la escuela de #{escuela.descripcion}"
      else
        flash[:danger] = 'No se pudo pudo eliminar la escuela. Por favor, inténtelo de nuevo.'
      end
      redirect_back fallback_location: usuario

    end
    # Fin Eliminar


  end
end