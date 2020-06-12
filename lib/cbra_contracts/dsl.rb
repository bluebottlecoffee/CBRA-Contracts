# frozen_string_literal: true

require 'cbra_contracts'
require 'cbra_contracts/contract'
require 'cbra_contracts/contract_method'

module CBRAContracts
  module DSL
    def self.extended(component)
      @@component = component
    end

    def define_contract(name, description)
      @@contract = Contract.new(name, description)
      add_contract_getter_and_setter
      @@component.contract = @@contract

      yield
    end

    def contract_method(name, description)
      contract_method = ContractMethod.new(name, description, @@component.to_s)
      @@contract.contract_methods << contract_method
      define_component_contract_method(contract_method)

      yield contract_method
    end

    # Class private; not meant to be used publicly
    def add_contract_getter_and_setter
      class << @@component
        def contract
          @@contract
        end

        def contract=(contract)
          @@contract = contract
        end
      end
    end

    # Class private; not meant to be used publicly
    def define_component_contract_method(contract_method)
      @@component.module_eval do
        self.define_method(contract_method.name) do |args|
          contract_method.invoke(args)
        end
        module_function contract_method.name
      end
    end
  end
end
