require 'test_helper'

class Cater::CallbacksTest < Minitest::Test
  
  class ServiceWithCallcacksClass
    include ::Cater::Service
    attr_accessor :attr_set_with_callback, :another_attr_set_with_callback
    
    after_call :set_after_call
    after_success :set_after_success
    after_error :set_after_error

    def call(should_fail:)
      if should_fail
        error!
      else
        false
      end
    end

    def set_after_call
      self.attr_set_with_callback = :set_after_call
    end

    def set_after_success
      self.another_attr_set_with_callback = :set_after_success
    end

    def set_after_error
      self.another_attr_set_with_callback = :set_after_error
    end

  end

  def setup
  end

  def test_after_call_on_success
    result = ServiceWithCallcacksClass.call(should_fail: false)
    assert_equal :set_after_call, result.attr_set_with_callback
  end

  def test_after_call_on_error
    result = ServiceWithCallcacksClass.call(should_fail: true)
    assert_equal :set_after_call, result.attr_set_with_callback
  end

  def test_after_error_set
    result = ServiceWithCallcacksClass.call(should_fail: true)
    assert_equal :set_after_error, result.another_attr_set_with_callback
  end

  def test_after_error_set
    result = ServiceWithCallcacksClass.call(should_fail: false)
    assert_equal :set_after_success, result.another_attr_set_with_callback
  end

end
