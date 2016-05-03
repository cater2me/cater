module Cater
  module Validators
    class Integer
      @default_options = {
        :nils => false,
        :min => nil,
        :max => nil,
        :in => nil
      }

      attr_accessor :options, :error_messages, :name

      def initialize(name, opts = {})
        self.options        = (@default_options || {}).merge(opts)
        self.name           = name
        self.error_messages = []
      end

      def validate(data)
        if (data.nil? || data == "") && !options[:nils]
          error_messages << "#{name} is required"
        end

        if !data.is_a?(Fixnum)
          if data.is_a?(String) && data =~ /^-?\d/
            data = data.to_i
          else
            error_messages << "#{name} is not an integer"
          end
        end

        if !data.is_a?(Integer)
          error_messages << "#{name} is not an integer"
        elsif options[:min] && data < options[:min]
          error_messages << "#{name} should be bigger or equal to #{options[:min]}"
        elsif options[:max] && data > options[:max]
          error_messages << "#{name} should be less or equal to #{options[:max]}"
        elsif options[:in] && !options[:in].include?(data)
          error_messages << "#{name} should be in #{options[:in]}"
        end          
      end
    end
  end
end