class AddCollectionToMenuLinks < ActiveRecord::Migration
  def change
    add_column :refinery_menus_links, :collection, :string
  end
end
