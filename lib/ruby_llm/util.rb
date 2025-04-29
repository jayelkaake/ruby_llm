module RubyLLM
  # Utility functions used everywhere
  module Util
    module_function

    ##
    # Recursively transforms keys in a hash or array to strings.
    # Borrowed from ActiveSupport's Hash#deep_transform_keys
    # @param object [Hash{String|Symbol => Object}] The object to transform.
    # @return [Hash{String => Object}] The transformed object.
    def deep_stringify_keys(object)
      deep_transform_keys_in_object(object, &:to_s)
    end

    ##
    # Recursively transforms keys in a hash or array to symbols.
    # Borrowed from ActiveSupport's Hash#deep_transform_keys
    # @param object [Hash{String|Symbol => Object}] The object to transform.
    # @return [Hash{Symbol => Object}] The transformed object.
    def deep_symbolize_keys(object)
      deep_transform_keys_in_object(object, &:to_sym)
    end

    ##
    # Recursively transforms keys in a hash or array to symbols.
    # Borrowed from ActiveSupport's Hash#deep_transform_keys
    # @param object [Object] The object to transform.
    # @param block [Proc] The block to apply to each key.
    # @return [Hash{String => Object}] The transformed object.
    def deep_transform_keys_in_object(object, &block)
      case object
      when Hash
        object.each_with_object({}) do |(key, value), result|
          result[yield(key)] = deep_transform_keys_in_object(value, &block)
        end
      when Array
        object.map { |e| deep_transform_keys_in_object(e, &block) }
      else
        object
      end
    end
  end
end
