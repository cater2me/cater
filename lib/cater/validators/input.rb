module Cater
  module Validators
    class Input
      attr_accessor :optional_inputs, :required_inputs, :error_messages

      def initialize(opts = {}, &block)
        @optional_inputs  = {}
        @required_inputs  = {}
        @current_inputs   = @required_inputs
        @error_messages   = {}

        if block_given?
          instance_eval &block
        end
      end

      def required(&block)
        @current_inputs = @required_inputs
        instance_eval &block
      end

      def optional
        @current_inputs = @optional_inputs
        instance_eval &block
      end

      def required_keys
        @required_inputs.keys
      end

      def optional_keys
        @optional_inputs.keys
      end

      def validate(args, service)
        required_inputs.each_pair do |attr, validator|
          validator.validate(args[attr])
          @error_messages["#{validator.name}"] = validator.error_messages if validator.error_messages.present?
        end
        service.error!(@error_messages) if @error_messages.present?
      end

      def boolean(name, options = {}, &block)
        @current_inputs[name.to_sym] = Cater::Validators::Boolean.new(name.to_sym, options)
      end

      def model(name, options = {}, &block)
        @current_inputs[name.to_sym] = Cater::Validators::Model.new(name.to_sym, options)
      end

    end
  end
end