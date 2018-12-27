class Profesor < ApplicationRecord
    # ASOCIACIONES:
	belongs_to :departamento
	accepts_nested_attributes_for :departamento

	belongs_to :usuario, foreign_key: :usuario_id 
	accepts_nested_attributes_for :usuario

	has_many :secciones
	accepts_nested_attributes_for :secciones

    has_many :profesor_secciones_secundarias,
        :class_name => 'SeccionProfesorSecundario',
        :foreign_key => :profesor_id

    accepts_nested_attributes_for :profesor_secciones_secundarias

    has_many :secciones_secundarias, through: :profesor_secciones_secundarias, source: :seccion

    # VALIDACIONES:
    validates :usuario_id, presence: true, uniqueness: true

    # FUNCIONES:
    def descripcion
        "#{usuario.descripcion} - #{departamento.descripcion if departamento}"
    end

    def descripcion_apellido
        "#{usuario.descripcion_apellido} - #{cal_departamento.descripcion if cal_departamento}"        
    end

    def descripcion_usuario
        if usuario
            return usuario.descripcion
        else
            "Profesor Sin descripcion"
        end
    end

end
