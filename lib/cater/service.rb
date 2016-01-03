module Cater
  class ServiceError < Exception; end

  module Service
    def self.included(base)
      base.extend ClassMethods
      base.class_eval do
        attr_accessor :message

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
    end

    module ClassMethods
      def serve(*args)
        instance = self.new
        begin
          instance.serve(*args)
          instance.send(:_service_success=, true)
        rescue ServiceError
          instance.send(:_service_success=, false)
        end
        
        return instance
      end
    end

  end
end