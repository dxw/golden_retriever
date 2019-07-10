# typed: false
# frozen_string_literal: true

module GoldenRetriever
  class Model
    class << self
      def attr_accessor(*attrs)
        attrs.each do |a|
          define_singleton_method "find_by_#{a}" do |value|
            find_by_attr(a, value)
          end
        end

        super(*attrs)
      end

      def all
        @all ||= begin
          @has_more = true
          @offset = nil
          @results = []

          append_page while @has_more == true

          @results.map { |d| send(:new, properties(d)) }
        end
      end

      def properties(item)
        item.properties.merge(id: item.send(self::ID_ATTRIBUTE))
      end

      def append_page
        page = hubspot_class.send(:all, properties: hubspot_properties, offset: @offset)
        @results += page[class_name.pluralize.downcase]
        @has_more = page['hasMore']
        @offset = page['offset']
      end

      def hubspot_class
        Object.const_get "Hubspot::#{class_name}"
      end

      def class_name
        name.split('::').last
      end

      def hubspot_properties
        self::HUBSPOT_PROPERTIES
      end

      def find_by_attr(key, value)
        all.find { |d| d.send(key).to_s == value.to_s }
      end

      def create(attrs)
        new(attrs).save
      end
    end
  end
end
