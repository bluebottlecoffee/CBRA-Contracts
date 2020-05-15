# frozen_string_literal: true

module CBRAContracts
  class ContractMethodParameter
    VALID_TYPES = %i[string integer float boolean].freeze
    VALID_HTTP_METHODS = %i[get post put patch update].freeze

    class InvalidTypeError < RuntimeError; end
    class InvalidHTTPMethodError < RuntimeError; end

    attr_reader :name, :type, :description, :http_method, :required

    def initialize(name:, type:, description: '', http_method: :get, required: true)
      raise InvalidTypeError unless VALID_TYPES.include?(type)
      raise InvalidHTTPMethodError unless VALID_HTTP_METHODS.include(http_method)

      @name = name
      @type = type
      @description = description
      @http_method = http_method
      @required = required
    end
  end
end
