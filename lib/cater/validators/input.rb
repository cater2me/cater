require 'active_model'

module Cater
  module Validators
    class Input
      include ActiveModel::Model

      attr_accessor :required_inputs, :errors

      def initialize(opts = {}, &block)
        @required_inputs  = {}
        @current_inputs   = @required_inputs
        self.errors       = ActiveModel::Errors.new(self)

        if block_given?
          instance_eval &block
        end
      end

      def required(&block)
        @current_inputs = @required_inputs
        instance_eval &block
      end

      def required_keys
        @required_inputs.keys
      end

      def validate(args, service)
        self.errors.clear
        required_inputs.each_pair do |attr, validator|
          validator.validate(args[attr])
          errors.add(validator.name, validator.errors[validator.name]) if validator.errors.any?
        end
        service.error!(errors) if errors.any?
      end

      def boolean(name, options = {}, &block)
        @current_inputs[name.to_sym] = Cater::Validators::Boolean.new(name.to_sym, options)
      end

      def model(name, options = {}, &block)
        @current_inputs[name.to_sym] = Cater::Validators::Model.new(name.to_sym, options)
      end

      def integer(name, options = {}, &block)
        @current_inputs[name.to_sym] = Cater::Validators::Integer.new(name.to_sym, options)
      end

    end
  end
end