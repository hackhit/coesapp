class CreatePerfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :perfiles do |t|
      t.string :nombre

      t.timestamps
    end
  end
end
