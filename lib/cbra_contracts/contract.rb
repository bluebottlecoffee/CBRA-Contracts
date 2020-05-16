# frozen_string_literal: true

module CBRAContracts
  class Contract
    attr_reader :contract_methods

    def initialize
      @contract_methods = []
    end

    def add_method(contract_method)
      @contract_methods << contract_method
    end

    # TODO: Extract to new object concerned with OpenApi generation
    def to_h
      @contract_methods.inject({}) do |hsh, contract_method|
        hsh[contract_method.path] = contract_method.to_h
        hsh
      end
    end
  end
end
