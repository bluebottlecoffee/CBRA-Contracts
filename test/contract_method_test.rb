# frozen_string_literal: true

require 'test_helper'
require 'cbra_contracts/contract_method'

class ContactMethodTest < Minitest::Test
  def setup
    @contract_method = CBRAContracts::ContractMethod.new(
      :test_method, 'A method to test param types and schema', self.class
    )
    @contract_method.param(:str, :string, 'String param')
    @contract_method.param(:int, :integer, 'Integer param')
    @contract_method.param(:flt, :float, 'Float param')
    @contract_method.param(:sym, :symbol, 'Symbol param')
    @contract_method.param(:hsh, :hash, 'Hash param')
    @contract_method.param(:bln, :bool, 'Boolean param')
    @contract_method.build_argument_schema
  end

  def test_parameter_types
    assert_equal :ok,
      @contract_method.invoke(
        str: 'hi',
        int: 8,
        flt: 8.8,
        sym: :ok,
        hsh: { a: 'nested', hash: 'param' },
        bln: true,
      )

    wrong_args = assert_raises ArgumentError do
      @contract_method.invoke(the: 'wrong', arguments: true)
    end
    assert wrong_args.message.include?('Argument [:str] is missing')

    wrong_types = assert_raises ArgumentError do
      @contract_method.invoke(str: 4)
    end
    assert wrong_types.message.include?('Argument [:str] must be a string')
  end

  class TestMethod
    #no op
    def call(*args)
      :ok
    end
  end
end
