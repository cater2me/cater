require 'test_helper'

class Cater::BooleanTest < Minitest::Test
  class ServiceClass
    include ::Cater::Service
    include ::Cater::Validator

    required do 
      boolean :should_fail
    end

    def call(should_fail:)
      if should_fail
        error!(message: "ERROR")
      else
        false
      end
    end
  end

  def setup
    @bool_validator = Cater::Validators::Boolean.new('paid')
  end

  def test_init_returns_instance
    assert @bool_validator.kind_of? Cater::Validators::Boolean
  end

  def test_responses_to_options
    @bool_validator.respond_to? :options
  end

  def test_responses_to_name
    @bool_validator.respond_to? :name
    assert_equal 'paid', @bool_validator.name
  end

  def test_default_options
    assert_equal false, @bool_validator.options[:nils] 
  end

  def test_validate_nils
    service = ServiceClass.call(should_fail:nil)
    assert_equal ['cannot be nil'], service.errors[:should_fail]
  end

  def test_validate_incorrect_value
    service = ServiceClass.call(should_fail:'ABC')
    assert_equal ['should be boolean'], service.errors[:should_fail]
  end

  def test_validate_string_boolean
    service = ServiceClass.call(should_fail:'true')
    assert_equal [], service.errors[:should_fail]
  end

  def test_validate_string_integer_boolean
    service = ServiceClass.call(should_fail:'true')
    assert_equal [], service.errors[:should_fail]
  end

  def test_validate_string_uppercase_boolean
    service = ServiceClass.call(should_fail:'FALSE')
    assert_equal [], service.errors[:should_fail]
  end

  def test_validate_integer_boolean
    service = ServiceClass.call(should_fail: 1)
    assert_equal [], service.errors[:should_fail]
  end  
end

