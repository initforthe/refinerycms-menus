module Refinery
  module Menus
    class Menu < Refinery::Core::BaseModel  
      self.table_name = "refinery_menus"

      has_many :links, :class_name => "::Refinery::Menus::MenuLink", :foreign_key => :refinery_menu_id, :dependent => :destroy, :order => "lft ASC"

      validates :title, :presence => true, :uniqueness => true
      validates :permatitle, :presence => true, :uniqueness => true
      validates_associated :links

      attr_accessible :title, :permatitle, :links, :links_attributes

      accepts_nested_attributes_for :links, :allow_destroy => true

      def roots
        @roots ||= prepared_links.select(&:root?)
      end

      def prepared_links
        @prepared_links ||= links.map { |link| link.collection? ? link.collection_links : link }.flatten
      end
    end
  end
end
