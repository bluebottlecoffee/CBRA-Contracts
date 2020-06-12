# frozen_string_literal: true

module CBRAContracts
  class Contract
    attr_reader :name, :description, :contract_methods

    def initialize(name, description)
      @name = name
      @description = description
      @contract_methods = []
    end

    def add_contract_method(contract_method)
      contract_methods << contract_method
    end
  end
end
