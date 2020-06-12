# frozen_string_literal: true

require 'test_helper'
require 'cbra_contracts/dsl'

class DslTest < Minitest::Test
  TestOutput = Struct.new(:works)
  module TestComponent
    extend CBRAContracts::DSL

    define_contract 'Test', 'A contract to test with' do
      contract_method :just_test_it, 'A simple method' do |m|
        m.param :when, :string, 'When to test it'
        m.param :why, :integer, 'A secret testing code'
        m.produces TestOutput
      end
    end

    class JustTestIt
      def call(*_args)
      end
    end
  end

  def test_that_a_contract_is_created
    assert_instance_of CBRAContracts::Contract, TestComponent.contract
  end

  def test_that_a_contract_method_is_created
    refute_empty TestComponent.contract.contract_methods
  end

  def test_that_contract_method_is_callable
    assert TestComponent.respond_to? :just_test_it
  end

  def test_implementation_class_automatically_set
    contract_method = TestComponent.contract.contract_methods.first

    assert_instance_of DslTest::TestComponent::JustTestIt,
                       contract_method.implementation
  end

  def test_arguments_passed_to_implementation
    mock_impl = Minitest::Mock.new
    mock_impl.expect(:call, true, [when: 'now', why: 2])
    contract_method = TestComponent.contract.contract_methods.first
    contract_method.implementation = mock_impl


    TestComponent.just_test_it(when: 'now', why: 2)

    mock_impl.verify

    # Reset it so future tests don't use mocked implementation
    contract_method.implementation = nil
  end

  def test_invalid_arguments
    wrong_args = assert_raises ArgumentError do
      TestComponent.just_test_it(the: 'wrong', arguments: true)
    end
    assert_equal 'Argument [:when] is missing, Argument [:why] is missing',
                 wrong_args.message

    wrong_types = assert_raises ArgumentError do
      TestComponent.just_test_it(when: 0, why: 'because')
    end
    assert_equal 'Argument [:when] must be a string, Argument [:why] must be an integer',
                 wrong_types.message
  end
end
