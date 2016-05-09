require 'test_helper'

class Cater::ValidatorTest < Minitest::Test
  class ServiceClass
    include ::Cater::Service
    include ::Cater::Validator

    required do 
      boolean :should_fail 
    end

    def call(should_fail:)
      if should_fail
        error!("ERROR")
      else
        false
      end
    end
  end

  def setup
    @input = ::Cater::Validator
  end

  def test_call_should_create_input_validators
    instance = ServiceClass.call(should_fail: 1)
    assert instance.input_validators
  end

  def test_responses_to_input_validators
    instance = ServiceClass.call(should_fail: 1)
    instance.respond_to? :input_validators
  end

  def test_module_responses_to_input_validators
    @input.respond_to? :input_validators
  end
end
