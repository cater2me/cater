module Cater
  module Validators
    class Model
      @default_options = {
        :class => nil,
        :new_records => false
      }

      attr_accessor :options, :error_messages, :name

      def initialize(name, opts = {})
        self.options        = (@default_options || {}).merge(opts)
        self.name           = name
        self.error_messages = []
      end

      def validate(data)
        _initialize_constants!

        if data.nil? || !data.is_a?(options[:class])
          error_messages << "#{name} model is required"
        elsif !options[:new_records] && (data.respond_to?(:new_record?) && data.new_record?)
          error_messages << "#{name} model is a new record" 
        end
      end

      private

      def _initialize_constants!
        @initialize_constants ||= begin
          class_const = options[:class] || name.to_s.camelize
          class_const = class_const.constantize if class_const.is_a?(String)
          options[:class] = class_const
          true
        end
      end

    end
  end
end
