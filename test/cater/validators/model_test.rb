require 'test_helper'

class Cater::ModelTest < Minitest::Test
  class Object::User
  end

  class ServiceClass
    include ::Cater::Service
    include ::Cater::Validator

    required do 
      model :user
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
      model :product
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
    @model_validator = Cater::Validators::Model.new('user')
  end

  def test_init_returns_instance
    assert @model_validator.kind_of? Cater::Validators::Model
  end

  def test_responses_to_options
    @model_validator.respond_to? :options
  end

  def test_responses_to_name
    @model_validator.respond_to? :name
    assert_equal 'user', @model_validator.name
  end

  def test_default_options
    assert_equal nil, @model_validator.options[:class] 
    assert_equal false, @model_validator.options[:new_records] 
  end

  def test_validate_nils
    service = ServiceClass.call(user:nil)
    assert_equal ['model is required'], service.errors[:user]
  end

  def test_validate_incorrect_type
    service = ServiceClass.call(user: 'ABC')
    assert_equal ['model is required'], service.errors[:user]
  end

  def test_validate_defunct_model
    service = ServiceClass2.call(product: 'ABC')
    assert_equal ['cannot find such model'], service.errors[:product]
  end
end

