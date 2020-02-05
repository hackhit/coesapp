class CreateAutorizadas < ActiveRecord::Migration[5.2]
  def change
    create_table :autorizadas, options: "ENGINE=InnoDB CHARSET=utf8" do |t|
      t.references :restringida,  null: false
      t.references :usuario, null: false, type: :string
    	t.index [:restringida_id, :usuario_id], unique: true
      t.timestamps
    end
    add_foreign_key :autorizadas, :restringidas, on_delete: :cascade, on_update: :cascade
    add_foreign_key :autorizadas, :usuarios, type: :string, primary_key: :ci, on_delete: :cascade, on_update: :cascade
    # add_index :autorizadas, [:restringida_id, :usuario_id], unique: true
  end
end
