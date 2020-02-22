class AddAdminUserReferenceToEmployees < ActiveRecord::Migration[6.0]
  def change
    add_reference :employees, :admin_user, null: false, foreign_key: true
  end
end
