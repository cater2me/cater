require 'active_support/concern'

module Cater
  module Validator
    extend ActiveSupport::Concern

    included do
      attr_accessor :input_validators

      def input_validators
        self.class.input_validators
      end
    end

    class_methods do
      def required(&block)
        self.input_validators.required(&block)
      end

      def input_validators
        @input_validators ||= Cater::Validators::Input.new
      end
    end

  end
end