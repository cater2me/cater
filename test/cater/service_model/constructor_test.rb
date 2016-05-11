require 'test_helper'
require 'active_model'

class Cater::ServiceModel::ConstructorTest < Minitest::Test
  
  class ExampleServiceModel
    include ::Cater::ServiceModel
    
    attribute :string_attribute,  String
    attribute :integer_attribute, Integer
    attribute :boolean_attribute, Boolean
    attribute :should_fail,       Boolean
    
    def call
      if should_fail?
        error!
      else
        false
      end
    end
  end

  def setup
  end

  def test_attribute_typecasting
    service_model = ExampleServiceModel
                    .(string_attribute: 42,
                      integer_attribute: '42',
                      boolean_attribute: '1',
                      should_fail: false)
    assert service_model.string_attribute.kind_of? String
    assert service_model.integer_attribute.kind_of? Fixnum
    assert service_model.boolean_attribute.kind_of? TrueClass
  end

end
