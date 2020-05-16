# frozen_string_literal: true

module CBRAContracts
  class ContractMethodParameter
    VALID_TYPES = %i[string integer float boolean].freeze

    class InvalidTypeError < RuntimeError; end

    attr_reader :name, :type, :description, :required

    def initialize(name:, type:, description: '', required: true)
      raise InvalidTypeError unless VALID_TYPES.include?(type)

      @name = name
      @type = type
      @description = description
      @required = required
    end
  end
end
