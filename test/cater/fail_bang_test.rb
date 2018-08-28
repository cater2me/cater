require 'test_helper'

class Cater::FailBangTest < Minitest::Test
  class ServiceClass
    include ::Cater::Service

    def call(*error_args)
      if error_args.length > 0
        fail!(*error_args)
      else
        false
      end
    end

  end

  def setup
  end

  def test_call_on_class_returns_instance
    instance = ServiceClass.call("ERROR")
    assert instance.kind_of? ServiceClass
  end

  def test_success?
    instance = ServiceClass.call()
    assert instance.success?
    refute instance.error?
  end

  def test_error?
    instance = ServiceClass.call("ERROR")
    assert instance.error?
    refute instance.success?
  end

  def test_responses_to_message
    instance = ServiceClass.call("ERROR")
    instance.respond_to? :message
  end

  def test_content_of_message
    instance = ServiceClass.call("ERROR")
    assert_equal "ERROR", instance.message
  end

  def test_responses_to_success?
    instance = ServiceClass.call("ERROR")
    instance.respond_to? :success?
  end

  def test_responses_to_error?
    instance = ServiceClass.call("ERROR")
    instance.respond_to? :error?
  end

  def test_content_of_full_messages
    instance = ServiceClass.call("ERROR")
    assert_equal ["ERROR"], instance.errors.full_messages
  end

  def test_content_of_full_messages_with_attr
    instance = ServiceClass.call(name: "ERROR")
    assert_equal ["Name ERROR"], instance.errors.full_messages
  end

  def test_content_of_full_messages_with_attrs
    instance = ServiceClass.call({name: "ERROR", :email => 'is required'})
    expected = ["Name ERROR", 'Email is required']
    assert_equal expected, instance.errors.full_messages
  end

  def test_content_of_messages_base
    instance = ServiceClass.call("ERROR")
    expected = {:base=>["ERROR"]}
    assert_equal expected, instance.errors.messages
  end

  def test_content_of_messages
    instance = ServiceClass.call(name: "ERROR")
    expected = {:name=>["ERROR"]}
    assert_equal expected, instance.errors.messages
  end

  def test_content_of_few_messages
    instance = ServiceClass.call(name: "ERROR", name2: "ERROR2")
    expected = {:name=>["ERROR"], :name2 => ["ERROR2"]}
    assert_equal expected, instance.errors.messages
  end

  def test_content_with_message_as_symbol
    instance = ServiceClass.call(:invalid)
    expected = {:base=>["is invalid"]}
    assert_equal expected, instance.errors.messages
  end

end
