module Cater
  module Validators
    class Model
      DEFAULTS = {
        :class => nil,
        :new_records => false
      }

      attr_accessor :options, :name

      def initialize(name, opts = {})
        self.options        = (DEFAULTS || {}).merge(opts)
        self.name           = name
      end

      def validate(data: data, service: service)
        _initialize_constants!(service)

        if data.nil? || !data.is_a?(options[:class])
          service.error!("model is required", name)
        elsif !options[:new_records] && (data.respond_to?(:new_record?) && data.new_record?)
          service.error!("model is a new record", name)
        end
      end

      private

      def _initialize_constants!(service)
        @initialize_constants ||= begin
          class_const = options[:class] || name.to_s.camelize
          begin
            class_const = class_const.constantize if class_const.is_a?(String)
            options[:class] = class_const
            true
          rescue Exception
            service.error!("cannot find such model", name)
          end
        end
      end

    end
  end
end
