# frozen_string_literal: true

module RubyLLM
  ##
  # Schema class for defining the structure of data objects.
  # Wraps the #Hash class
  # @see #Hash
  class Schema
    delegate_missing_to :@schema

    ##
    # @param type [Symbol] (optional) This can be anything supported by the API JSON schema types (integer, object, etc)
    # @param schema [Hash] The schema for the response format. It can be a JSON schema or a simple hash.
    def initialize(type = nil, **schema)
      schema_hash = if type.is_a?(Symbol) || type.is_a?(String)
                      { type: type == :json ? :object : type }
                    elsif type.is_a?(Hash)
                      type
                    else
                      {}
                    end.merge(schema)

      @schema = Util.deep_symbolize_keys(schema_hash)
    end

    def [](key)
      @schema[key.to_sym]
    end

    def []=(key, new_value)
      @schema[key.to_sym] = Util.deep_symbolize_keys(new_value)
    end

    # Adds the new_value into the new_key key for every sub-schema that is of type: :object
    # @param new_key [Symbol] The key to add to each object type.
    # @param new_value [Boolean, String] The value to assign to the new key.
    def add_to_each_object_type!(new_key, new_value)
      add_to_each_object_type(new_key, new_value, @schema)
    end

    # @return [Boolean]
    def present?
      @schema.present? && @schema[:type].present?
    end

    private

    def add_to_each_object_type(new_key, new_value, schema)
      return schema unless schema.is_a?(Hash)

      if schema[:type].to_s == :object.to_s
        add_to_object_type(new_key, new_value, schema)
      elsif schema[:type].to_s == :array.to_s && schema[:items]
        schema[:items] = add_to_each_object_type(new_key, new_value, schema[:items])
      end

      schema
    end

    def add_to_object_type(new_key, new_value, schema)
      if schema[new_key.to_sym].nil?
        schema[new_key.to_sym] = new_value.is_a?(Proc) ? new_value.call(schema) : new_value
      end

      schema[:properties]&.transform_values! { |value| add_to_each_object_type(new_key, new_value, value) }
    end
  end
end
