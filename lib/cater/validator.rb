require 'active_support/concern'
require 'active_support/callbacks'
require 'active_model'

module Cater
  class ServiceError < Exception; end

  module Validator
    extend ActiveSupport::Concern

    included do
      include ActiveModel::Model

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