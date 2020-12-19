# frozen_string_literal: true

require 'dry/inflector'
require 'dry/schema'
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

    def param(name, type, description, opts = {})
      @params << Parameter.new(name, type, description, opts)
    end

    def produces(klass)
      @return_type = klass
    end

    def invoke(args = {})
      return implementation.call if args.empty?

      valid = argument_schema.call(args)
      if valid.success?
        implementation.call(valid.to_h)
      else
        raise_argument_error(valid.errors.messages)
      end
    end

    def implementation
      @implementation ||= Object.const_get(default_impl_class).new
    end

    def implementation=(impl)
      @implementation = impl
    end

    def build_argument_schema
      schema = Dry::Schema::DSL.new
      params.each do |p|
        if p.required?
          schema.required(p.name).filled(p.type)
        else
          schema.optional(p.name).filled(p.type)
        end
      end

      @argument_schema = schema.call
    end

    private

    attr_reader :impl_scope, :argument_schema

    def default_impl_class
      "#{impl_scope}::#{Dry::Inflector.new.classify(name)}"
    end

    def raise_argument_error(error_messages)
      msg = error_messages.map do |m|
        "Argument #{m.path} #{m.text}"
      end.join(', ')

      raise ArgumentError, msg
    end
  end
end
