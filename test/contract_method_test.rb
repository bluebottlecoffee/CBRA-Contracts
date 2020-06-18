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
    assert_equal :ok, @contract_method.invoke(valid_params)

    wrong_args = assert_raises ArgumentError do
      @contract_method.invoke(the: 'wrong', arguments: true)
    end
    assert wrong_args.message.include?('Argument [:str] is missing')

    wrong_types = assert_raises ArgumentError do
      @contract_method.invoke(str: 4)
    end
    assert wrong_types.message.include?('Argument [:str] must be a string')
  end

  def test_extra_params_are_filtered
    mock_impl = Minitest::Mock.new
    mock_impl.expect(:call, true, [valid_params])

    @contract_method.implementation = mock_impl
    @contract_method.invoke(valid_params.merge(an: 'extra one'))

    mock_impl.verify

    # Reset it so future tests don't use mocked implementation
    @contract_method.implementation = nil
  end

  def test_optional_params
    cm = @contract_method.dup
    cm.param(:opt, :string, 'An optional param', required: false)
    cm.build_argument_schema
    new_params = valid_params.merge(opt: 'I am here this time')

    mock_impl = Minitest::Mock.new
    mock_impl.expect(:call, true, [new_params])

    cm.implementation = mock_impl
    cm.invoke(new_params)

    mock_impl.verify

    # Now make sure you can still call _without_ the optional param
    mock_impl.expect(:call, true, [valid_params])
    cm.invoke(valid_params)

    mock_impl.verify
  end

  class TestMethod
    #no op
    def call(*args)
      :ok
    end
  end

  private

  def valid_params
    {
      str: 'hi',
      int: 8,
      flt: 8.8,
      sym: :ok,
      hsh: { a: 'nested', hash: 'param' },
      bln: true,
    }
  end
end
