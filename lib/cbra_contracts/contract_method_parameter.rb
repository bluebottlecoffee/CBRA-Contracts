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
      bool
      array
    ].freeze

    attr_reader :name, :type, :description, :required

    def initialize(name, type, description, opts)
      raise InvalidParameterType unless VALID_TYPES.include?(type)

      @name = name
      @type = type
      @description = description
      @required = opts.fetch(:required) { true }
    end

    def required?
      required
    end
  end
end
