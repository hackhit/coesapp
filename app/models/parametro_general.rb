class ParametroGeneral < ApplicationRecord
  # SET GLOBALES:
  self.table_name = 'parametros_generales'

  def self.periodo_actual_id
    ParametroGeneral.where(id: "SEMESTRE_ACTUAL").first.valor
  end

  def self.periodo_actual
    id = self.periodo_actual_id
    Periodo.where(id: id).limit(1).first
  end

end 
