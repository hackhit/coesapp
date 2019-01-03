class CreateJoinTableDepartamentosCatedras < ActiveRecord::Migration[5.2]
  def change
    create_table 'catedradepartamentos' do |t|
      t.references :departamento, type: :string
      t.references :catedra, type: :string
      t.index [:catedra_id, :departamento_id], unique: true
      t.index [:departamento_id, :catedra_id], unique: true
      t.integer :orden
      t.timestamps

    end
    add_foreign_key :catedradepartamentos, :departamentos, on_delete: :cascade,  on_update: :cascade
    add_foreign_key :catedradepartamentos, :catedras, on_delete: :cascade,  on_update: :cascade

  end
end


