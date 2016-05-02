module Cater
  module Validators
    class Boolean
      @default_options = {
        :nils => false
      }

      BOOL_MAP = {"true" => true, "1" => true, "false" => false, "0" => false}

      attr_accessor :options, :error_messages, :name

      def initialize(name, opts = {})
        self.options        = (@default_options || {}).merge(opts)
        self.error_messages = []
        self.name           = name
      end

      def validate(data)
        if data.nil? || data == ""
          return true if options[:nils]
          return error_messages << "#{name} is required"
        end

        if data == true || data == false
          return true
        end

        data = data.to_s if data.is_a?(Fixnum)

        if data.is_a?(String)
          res = BOOL_MAP[data.downcase]
          return true unless res.nil?
          return error_messages << "#{name} shoud be a boolean"
        else
          return error_messages << "#{name} is required"
        end
      end
    end
  end
end