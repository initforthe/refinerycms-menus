class AddCollectionToMenuLinks < ActiveRecord::Migration
  def change
    add_column :refinery_menu_links, :collection, :string
  end
end
