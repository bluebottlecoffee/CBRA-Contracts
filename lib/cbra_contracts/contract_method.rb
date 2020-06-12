# frozen_string_literal: true

require 'dry/inflector'
require 'cbra_contracts/contract_method_parameter'

module CBRAContracts
  class ContractMethod
    attr_reader :name, :description, :params, :return_type

    def initialize(name, description, impl_scope)
      @name = name
      @description = description
      @impl_scope = impl_scope
      @params = []
    end

    def param(name, type, description)
      @params << Parameter.new(name, type, description)
    end

    def produces(klass)
      @return_type = klass
    end

    def invoke(args)
      # validate args against schema
      implementation.call(args)
    end

    def implementation
      @implementation ||= Object.const_get(default_impl_class).new
    end

    def implementation=(impl)
      @implementation = impl
    end

    private

    attr_reader :impl_scope

    def default_impl_class
      "#{impl_scope}::#{Dry::Inflector.new.classify(name)}"
    end
  end
end
