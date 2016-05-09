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
          service.error!("cannot be nil", name)
        end

        if !data.is_a?(Fixnum)
          if data.is_a?(String) && data =~ /^-?\d/
            data = data.to_i
          end
        end

        if !data.is_a?(Integer) && !data.is_a?(Fixnum)
          service.error!("is not an integer", name)
        elsif options[:min] && data < options[:min]
          service.error!( "should be bigger or equal to #{options[:min]}", name)
        elsif options[:max] && data > options[:max]
          service.error!( "should be less or equal to #{options[:max]}", name)
        elsif options[:in] && !options[:in].include?(data)
          service.error!( "should be from #{options[:in].first} to #{options[:in].last}", name)
        end          
      end
    end
  end
end