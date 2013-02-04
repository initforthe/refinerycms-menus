module Refinery
  module Menus
    module InstanceMethods

      def self.included(base)
        base.send :helper_method, :refinery_menu
      end

      # Compiles a menu.
      def refinery_menu(menu_title)
        ::Refinery::Menu.new(::Refinery::Menu.find_or_create_by_permatitle(menu_title).links).roots
      end
      alias_method :refinery_menu, :refinery_page_menu

    end
  end
end