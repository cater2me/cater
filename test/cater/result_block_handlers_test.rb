require 'test_helper'

class Cater::ResultBlockHandlersTest < Minitest::Test
  class ServiceClass
    include ::Cater::Service
    include ::Cater::Validator

    attr_accessor :outcome

    def call(should_fail:)
      if should_fail
        self.outcome=0
        error!
      else
        self.outcome=42
        false
      end
    end

  end

  def setup
  end

  def test_call_on_class_returns_instance
    instance = ServiceClass.call(should_fail: 1)
    assert instance.kind_of? ServiceClass
  end

  def test_on_success
    variable_to_assert = nil
    instance = ServiceClass
               .call(should_fail: false)
               .on_success{|r| variable_to_assert = r.outcome}
               .on_error{|r| variable_to_assert = nil}
    assert instance.success?
    assert_equal 42, instance.outcome
    assert_equal 42, variable_to_assert
  end

  def test_on_error
    variable_to_assert = nil
    instance = ServiceClass
               .call(should_fail: true)
               .on_error{|r| variable_to_assert = r.outcome}
               .on_success{|r| variable_to_assert = nil}
    assert instance.error?
    assert_equal 0, instance.outcome
    assert_equal 0, variable_to_assert
    refute instance.success?
  end

end
