class CreatePlanes < ActiveRecord::Migration[5.2]
  def change
    create_table :planes, id: false do |t|
      t.string :id, null: false
      t.string :description

      t.timestamps
    end
    reversible do |direction|
      direction.up { execute('ALTER TABLE planes ADD PRIMARY KEY (id);')}
    end

  end
end
