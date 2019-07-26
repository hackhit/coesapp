module Admin
  class GradosController < ApplicationController
    # Privilegios
    before_action :filtro_logueado
    before_action :filtro_administrador

    def cambiar_estado
      estado = params[:estado].to_i
        escuela_id, estudiante_id = params[:id].split("-")
        grado = Grado.where(escuela_id: escuela_id, estudiante_id: estudiante_id).first
      if estado.eql? 1
        escuelas_ids = current_admin.escuelas.ids
        # Creo que pudieran publicarse todas los grados no solo del periodo como en la linea d abajo
        # inscripcion = grado.inscripciones.grados.de_la_escuela(escuela_id).first
        inscripcion = grado.inscripciones.grados.del_periodo(current_periodo.id).de_la_escuela(escuela_id).first
        estado_anterior = inscripcion.estado
        info_bitacora "Cambio de estado del estudiante #{estudiante_id} de #{estado_anterior} a #{inscripcion.estado}", Bitacora::ACTUALIZACION, inscripcion if inscripcion.update_attributes(estado: :sin_calificar)
      elsif estado > 1
        Grado.where(escuela_id: escuela_id, estudiante_id: estudiante_id).update_all(estado: estado)
      end
      tr = view_context.render partial: '/admin/grados/detalle_registro', locals: {registro: grado, estado: estado}
      msg = "Cambio de estado de #{grado.estudiante.usuario.descripcion}"

      render json: {tr: tr, msg: msg}, status: :ok

    end

    def agregar
      @estudiante = Estudiante.find params[:id]
      @escuela = Escuela.find params[:escuela_id]

      if @estudiante.grados.create(escuela_id: params[:escuela_id])
        info_bitacora "Registrado en Escuela #{@escuela.descripcion}", Bitacora::CREACION, @estudiante
        flash[:success] = '¡Registro exitoso en escuela!'
      else
        flash[:danger] = 'Error al intentar registrar en Escuela. Por favor verifique e inténtelo de nuevo.'
      end
      redirect_to usuario_path(@estudiante.id)

    end

    def index
      escuelas_ids = current_admin.escuelas.ids

      @tesistas = Inscripcionseccion.grados.del_periodo(current_periodo.id).de_las_escuelas(escuelas_ids).sin_calificar
      @posibles_graduandos = Grado.posible_graduando
      @graduandos = Grado.graduando
      @graduados = Grado.graduado
      # @graduandos = @grados.aprobado

    end
    # Fin Index

    def eliminar
      escuela_id, estudiante_id = params[:id].split("-")
      escuela = Escuela.find escuela_id
      usuario = Usuario.find estudiante_id

      grados = Grado.where(escuela_id: escuela_id, estudiante_id: estudiante_id)
      inscripciones = grados.first.inscripciones
      total = 0
      if params[:escuela_destino_id] and inscripciones.any?
        inscripciones.each do |inscrip|
          inscrip.pci_escuela_id = params[:escuela_destino_id]
          total += 1 if inscrip.save
        end
      end

      info_bitacora_crud Bitacora::ELIMINACION, grados.first
      if grados.delete_all
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