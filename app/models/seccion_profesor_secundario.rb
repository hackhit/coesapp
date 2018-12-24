class SeccionProfesorSecundario < ApplicationRecord

	belongs_to :seccion

	belongs_to :profesor, primary_key: :usuario_ci

	belongs_to :tipo_estado_calificacion

	belongs_to :tipo_estado_inscripcion

end
