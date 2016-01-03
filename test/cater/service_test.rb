require 'test_helper'

class Cater::ServiceTest < Minitest::Test
  class ServiceClass
    include ::Cater::Service

    def serve(should_fail:)
      if should_fail
        error!
      else
        false
      end
    end
  end

  def setup
  end

  def test_serve_on_class_returns_instance
    instance = ServiceClass.serve(should_fail: 1)
    assert instance.kind_of? ServiceClass
  end

  def test_success?
    instance = ServiceClass.serve(should_fail: false)
    assert instance.success?
    refute instance.error?
  end

  def test_error?
    instance = ServiceClass.serve(should_fail: true)
    assert instance.error?
    refute instance.success?
  end

  def test_responses_to_message
    instance = ServiceClass.serve(should_fail: 1)
    instance.respond_to? :message
  end

  def test_responses_to_success?
    instance = ServiceClass.serve(should_fail: 1)
    instance.respond_to? :success?
  end

  def test_responses_to_error?
    instance = ServiceClass.serve(should_fail: 1)
    instance.respond_to? :error?
  end
end
