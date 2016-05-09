module Cater
  module Validators
    class Boolean
      DEFAULTS = {
        :nils => false
      }

      BOOL_MAP = {
        "true" => true, "TRUE" => true, "1" => true, 1 => true, true => true,
        "false" => false, "FALSE" => false, "0" => false, 0 => false, false => false
      }

      attr_accessor :options, :name

      def initialize(name, opts = {})
        self.options = (DEFAULTS || {}).merge(opts)
        self.name    = name
      end

      def validate(data:nil, service:)
        if data.nil? || data == ""
          service.error!("cannot be nil", name) unless options[:nils]
        else
          data = data.to_s if data.is_a?(Fixnum)
          res = BOOL_MAP[data]
          if res.nil?
            service.error!( "should be boolean", name) 
          end
        end
      end

    end
  end
end