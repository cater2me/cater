require 'active_support/concern'
require 'active_support/callbacks'

module Cater
  class ServiceError < Exception; end

  module Service
    extend ActiveSupport::Concern

    included do
      include ActiveSupport::Callbacks

      attr_accessor :message
      define_callbacks :serve

      def success?
        fail "Service was not called yet" if @_service_success.nil?
        @_service_success
      end

      def error!(message=nil)
        message = message
        raise ServiceError
      end

      def error?
        !success?
      end

      private
      
      def _service_success=(result)
        @_service_success = result
      end
    end

    class_methods do
      def after_serve(*filters, &blk)
        set_callback(:serve, :after, *filters, &blk)
      end

      def around_serve(*filters, &blk)
        set_callback(:serve, :around, *filters, &blk)
      end

      def before_serve(*filters, &blk)
        set_callback(:serve, :before, *filters, &blk)
      end

      def serve(*args)
        instance = self.new
        begin
          instance.run_callbacks :serve do
            instance.serve(*args)
          end
          instance.send(:_service_success=, true)
        rescue ServiceError
          instance.send(:_service_success=, false)
        end
        
        return instance
      end
    end

  end
end