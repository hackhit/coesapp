class CreatePeriodos < ActiveRecord::Migration[5.2]
  def change
    create_table :periodos, id: false do |t|
      t.string :id, null: false
      t.date :inicia
      t.date :culmina

      t.timestamps
    end

    reversible do |direction|
      direction.up { execute('ALTER TABLE periodos ADD PRIMARY KEY (id);')}
    end
  end

end

