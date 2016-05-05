require 'test_helper'
require 'active_model'

class Cater::ModelTest < Minitest::Test
  
  class ServiceModel
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

  def test_errors_object_presence
    model = ServiceModel.call(should_fail: false)
    assert model.valid?
    assert model.errors.blank?
  end

  def test_errors_object_presence
    model = ServiceModel.call(should_fail: true)
    refute model.errors.blank?
  end

end
