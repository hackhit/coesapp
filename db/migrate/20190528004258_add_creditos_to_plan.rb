class AddCreditosToPlan < ActiveRecord::Migration[5.2]
  def change
  	add_column :planes, :creditos, :integer, default: 0
  end
end
