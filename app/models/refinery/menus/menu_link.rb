require 'initforthe-routes'

module Refinery
  module Menus
    class MenuLink < Refinery::Core::BaseModel
      self.table_name = "refinery_menus_links"

      attr_accessible :parent_id, :refinery_page_id, :refinery_menu_id, :refinery_resource_id, :refinery_resource_type,
                      :title_attribute, :custom_url, :label, :menu, :id_attribute, :class_attribute, :collection

      belongs_to :menu, :class_name => '::Refinery::Menus::Menu', :foreign_key => :refinery_menu_id
      belongs_to :resource, :foreign_key => :refinery_resource_id, :polymorphic => true

      # Docs for acts_as_nested_set https://github.com/collectiveidea/awesome_nested_set
      # rather than :delete_all we want :destroy
      acts_as_nested_set :dependent => :destroy

      validates :menu, :presence => true
      validates :label, :presence => true

      before_validation :set_label

      def self.find_all_of_type(type)
        # find all resources of the given type, determined by the configuration
        if scope = self.resource_config(type)[:scope]
          scope.is_a?(Symbol) ? resource_klass(type).send(scope) : resource_klass(type).instance_exec(&scope)
        else
          resource_klass(type).all
        end
      end

      def self.resource_klass(type)
        resource_config(type)[:klass].constantize
      end

      def self.resource_config(type)
        Refinery::Menus.menu_resources[type.to_sym]
      end

      def set_label
        return if label.present?

        self.label = if collection?
            "Collection: #{collection}"
          elsif custom_link?
            begin
              custom_url.match(/(\w+)\.\w+$/).captures.join.titleize
            rescue
              custom_url
            end
          else
            resource_title
          end
      end

      def resource_klass
        Refinery::Menus::MenuLink.resource_klass(resource_type)
      end

      def resource_config
        Refinery::Menus::MenuLink.resource_config(resource_type)
      end

      def resource_type
        refinery_resource_type || "Custom link"
      end

      def root?
        parent_id.nil?
      end

      def type_name
        resource_type.titleize
      end

      def collection?
        collection.present?
      end

      def collection_links
        @collection_links ||= begin
          collector = resource_config[:collections][collection]
          resource_klass.instance_exec(&collector).map do |item|
            build_collection_link(item)
          end
        end
      end

      def build_collection_link(resource)
        dup.tap do |item|
          item.collection = nil
          item.label = nil
          item.refinery_resource_id = resource.id
          item.set_label
        end
      end

      def custom_link?
        refinery_resource_id.nil? || refinery_resource_type.nil?
      end

      def resource_link?
        refinery_resource_id.present? && refinery_resource_type.present?
      end

      def resource
        return nil if custom_link? || collection?
        resource_klass.find(refinery_resource_id)
      end

      def resource_title
        resource.send(resource_config[:title_attr])
      end

      def title
        title_attribute.present? ? title_attribute : label
      end

      def resource_url
        if resource.respond_to?(:url)
          resource.url
        elsif resource_config[:url]
          Initforthe::Routes.route(resource, &resource_config[:url])
        else
          '/'
        end
      end

      def url
        if custom_link?
          custom_url
        else
          resource_url
        end
      end

      def as_json(options={})
        json = super(options)
        if resource_link?
          json = {
            resource: {
              title: resource_title
            }
          }.merge(json)
        end
        json
      end

      def to_refinery_menu_item
        {
          :id => id,
          :lft => lft,
          :menu_match => menu_match,
          :parent_id => parent_id,
          :rgt => rgt,
          :title => label,
          :type => self.class.name,
          :url => url,
          :html => {
            :id => id_attribute,
            :class => class_attribute,
            :title => title
          }
        }
      end

    end
  end
end
