require 'active_model'

module Cater
  module Validators
    class Boolean
      include ActiveModel::Model

      @default_options = {
        :nils => false
      }

      BOOL_MAP = {
        "true" => true, "TRUE" => true, "1" => true, 1 => true, true => true,
        "false" => false, "FALSE" => false, "0" => false, 0 => false, false => false
      }

      attr_accessor :options, :name, :errors

      def initialize(name, opts = {})
        self.options    = (@default_options || {}).merge(opts)
        self.name       = name
        self.errors     = ActiveModel::Errors.new(self)
      end

      def validate(data)
        self.errors.clear
        
        if data.nil? || data == ""
          errors.add(name, "cannot be nil") unless options[:nils]
        end

        data = data.to_s if data.is_a?(Fixnum)

        res = BOOL_MAP[data]
        if res.nil?
          errors.add(name, "cannot be nil") 
        end
      end

    end
  end
end