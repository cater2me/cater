require 'test_helper'

class Cater::InputTest < Minitest::Test
  class ServiceClass
    include ::Cater::Service

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
    @input = Cater::Validators::Input.new
  end

  def model_block
    Proc.new{ required do model :order end}
  end

  def boolean_block
    Proc.new{ required do boolean :paid end}
  end

  def integer_block
    Proc.new{ required do integer :order_id end}
  end

  def test_init_without_args_returns_instance
    assert @input.kind_of? Cater::Validators::Input
  end

  def test_return_required_inputs
    @input.respond_to? :required_inputs
  end

  def test_call_required_with_block_initialize_model_validation
    @input.send(:required, &model_block)
    assert_instance_of(Cater::Validators::Model, @input.required_inputs[:order])
  end

  def test_call_required_with_block_initialize_boolean_validation
    @input.send(:required, &boolean_block)
    assert_instance_of(Cater::Validators::Boolean, @input.required_inputs[:paid])
  end

  def test_call_required_with_block_initialize_integer_validation
    @input.send(:required, &integer_block)
    assert_instance_of(Cater::Validators::Integer, @input.required_inputs[:order_id])
  end

  def test_call_required_with_block_set_required_keys
    @input.send(:required, &model_block)
    assert_equal [:order], @input.required_keys
  end

  def test_validate_clean_errors
    args = { paid: true }
    service = ServiceClass.call(args)
    @input.send(:required, &boolean_block)

    service.errors.add(:paid, 'missing')
    assert_equal ['missing'], service.errors[:paid]

    @input.validate(args, service)
    assert_equal [], service.errors[:paid]
  end
end

