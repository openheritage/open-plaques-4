class AddAbstractToPages < ActiveRecord::Migration[8.1]
  def change
    add_column :pages, :abstract, :text
  end
end
