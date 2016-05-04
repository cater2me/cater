module Cater
  module Validators
    class Integer
      DEFAULTS = {
        :nils => false,
        :min => nil,
        :max => nil,
        :in => nil
      }

      attr_accessor :options, :name

      def initialize(name, opts = {})
        self.options        = (DEFAULTS || {}).merge(opts)
        self.name           = name
      end

      def validate(data: data, service: service)
        if (data.nil? || data == "") && !options[:nils]
          service.error!(attr: name, message: "cannot be nil")
        end

        if !data.is_a?(Fixnum)
          if data.is_a?(String) && data =~ /^-?\d/
            data = data.to_i
          end
        end

        if !data.is_a?(Integer) && !data.is_a?(Fixnum)
          service.error!(attr: name, message:"is not an integer")
        elsif options[:min] && data < options[:min]
          service.error!(attr: name, message: "should be bigger or equal to #{options[:min]}")
        elsif options[:max] && data > options[:max]
          service.error!(attr: name, message: "should be less or equal to #{options[:max]}")
        elsif options[:in] && !options[:in].include?(data)
          service.error!(attr: name, message: "should be from #{options[:in].first} to #{options[:in].last}")
        end          
      end
    end
  end
end