# frozen_string_literal: true

module CBRAContracts
  class Parameter
    class InvalidParameterType < Error; end

    VALID_TYPES = %i[
      string
      integer
      float
      symbol
      hash
    ].freeze

    attr_reader :name, :type, :description

    def initialize(name, type, description)
      raise InvalidParameterType unless VALID_TYPES.include?(type)

      @name = name
      @type = type
      @description = description
    end
  end
end
