class AddCitationToRoles < ActiveRecord::Migration[8.1]
  def change
    add_column :roles, :citation, :string
  end
end
