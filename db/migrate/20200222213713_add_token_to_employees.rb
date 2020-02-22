class AddTokenToEmployees < ActiveRecord::Migration[6.0]
  def change
    add_column :employees, :token, :string, null: false
  end
end
