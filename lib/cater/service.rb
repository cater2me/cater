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


# require 'active_support/concern'

# module Service

#   class ServiceError < Exception; end
#   extend ActiveSupport::Concern

#   included do
#     attr_accessor :success, :message

#     def success?
#       fail "Service was not called!" if success.nil?
#       !!success
#     end

#     def error?
#       fail "Service was not called!" if success.nil?
#       !success
#     end

#     def error(message=nil)
#       message = message
#       fail ServiceError.new(message)
#     end
#   end

#   class_methods do
#     def sync_execution_method(method_name)
#     end

#     def async_execution_method(method_name)
#     end

#     def call(*args)
#       begin
#         instance = self.new(*args)
#         instance.call!
#         instance.success = true
#       rescue ServiceError
#         instance.success = false
#       end
#       instance
#     end
#   end

# end