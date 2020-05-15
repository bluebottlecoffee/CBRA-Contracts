# frozen_string_literal: true

module CBRAContracts
  class Contract
    attr_reader :contract_methods

    def intitialze
      @contract_methods = []
    end

    def add_method(contract_method)
      @contract_methods << contract_method
    end
  end
end
