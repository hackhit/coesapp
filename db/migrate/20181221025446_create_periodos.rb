class CreatePeriodos < ActiveRecord::Migration[5.2]
  def change
    create_table :periodos, id: false do |t|
      t.string :id, null: false, index: true, primary_key: true
      t.date :inicia
      t.date :culmina

      t.timestamps
    end
  end

end

