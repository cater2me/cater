require 'test_helper'

class Cater::IntegerTest < Minitest::Test
  class ServiceClass
    include ::Cater::Service
    include ::Cater::Validator

    required do 
      integer :amount, min: 10, max: 20
    end

    def call(should_fail:)
      if should_fail
        error!(message: "ERROR")
      else
        false
      end
    end
  end

  class ServiceClass2
    include ::Cater::Service
    include ::Cater::Validator

    required do 
      integer :amount, in: [30,40]
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
    @integer_validator = Cater::Validators::Integer.new('amount')
  end

  def test_init_returns_instance
    assert @integer_validator.kind_of? Cater::Validators::Integer
  end

  def test_responses_to_options
    @integer_validator.respond_to? :options
  end

  def test_responses_to_name
    @integer_validator.respond_to? :name
    assert_equal 'amount', @integer_validator.name
  end

  def test_default_options
    assert_equal false, @integer_validator.options[:nils] 
    assert_equal nil, @integer_validator.options[:min] 
    assert_equal nil, @integer_validator.options[:max] 
    assert_equal nil, @integer_validator.options[:in] 
  end

  def test_validate_nils
    service = ServiceClass.call(amount:nil)
    assert_equal ['cannot be nil'], service.errors[:amount]
  end

  def test_validate_incorrect_type
    service = ServiceClass.call(amount: 'ABC')
    assert_equal ['is not an integer'], service.errors[:amount]
  end

  def test_validate_min_value
    service = ServiceClass.call(amount: 5)
    assert_equal ['should be bigger or equal to 10'], service.errors[:amount]
  end

  def test_validate_max_value
    service = ServiceClass.call(amount: 100)
    assert_equal ['should be less or equal to 20'], service.errors[:amount]
  end

  def test_validate_value_in_allowed_range
    service = ServiceClass2.call(amount: 100)
    assert_equal ['should be from 30 to 40'], service.errors[:amount]
  end
end

