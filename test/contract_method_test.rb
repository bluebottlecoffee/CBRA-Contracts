# frozen_string_literal: true

require 'test_helper'
require 'cbra_contracts/contract_method'

class ContactMethodTest < Minitest::Test
  def setup
    @contract_method = CBRAContracts::ContractMethod.new(
      :test_method, 'A method to test param types and schema', self.class
    )
    @contract_method.param(:p1, :string, 'String param')
    @contract_method.param(:p2, :integer, 'Integer param')
    @contract_method.param(:p3, :float, 'Float param')
    @contract_method.param(:p4, :symbol, 'Symbol param')
    @contract_method.build_argument_schema
  end

  def test_parameter_types
    assert_equal :ok,
      @contract_method.invoke(p1: 'hi', p2: 8, p3: 8.8, p4: :ok)
    wrong_args = assert_raises ArgumentError do
      @contract_method.invoke(the: 'wrong', arguments: true)
    end
    assert wrong_args.message.include?('Argument [:p1] is missing')

    wrong_types = assert_raises ArgumentError do
      @contract_method.invoke(p1: 4)
    end
    assert wrong_types.message.include?('Argument [:p1] must be a string')
  end

  class TestMethod
    #no op
    def call(*args)
      :ok
    end
  end
end
