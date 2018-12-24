class Profesor < ApplicationRecord

	belongs_to :departamento
	accepts_nested_attributes_for :departamento

	belongs_to :usuario, foreign_key: :usuario_id 
	accepts_nested_attributes_for :usuario

	belongs_to :seccion
	accepts_nested_attributes_for :seccion

    has_many :profesor_secciones_secundarias,
        :class_name => 'SeccionProfesorSecundario',
        :foreign_key => :cal_profesor_ci

    accepts_nested_attributes_for :profesor_secciones_secundarias

    has_many :secciones_secundarias, through: :profesor_secciones_secundarias, source: :seccion



    def descripcion
        "#{usuario.descripcion} - #{departamento.descripcion if departamento}"
    end

    def descripcion_apellido
        "#{usuario.descripcion_apellido} - #{cal_departamento.descripcion if cal_departamento}"        
    end

    def descripcion_usuario
        if cal_usuario
            return cal_usuario.descripcion
        else
            "Profesor Sin descripcion"
        end
    end

end
