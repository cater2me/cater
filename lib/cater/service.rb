require 'active_support/concern'
require 'active_support/callbacks'
require 'active_model'

module Cater
  class ServiceError < Exception; end

  module Service
    extend ActiveSupport::Concern

    included do
      include ActiveModel::Model
      include ActiveSupport::Callbacks

      attr_accessor :message

      define_callbacks :call, :success, :error

      def success?
        fail "Service was not called yet" if @_service_success.nil?
        @_service_success
      end

      # raise error
      #
      # error! "Something is required"
      # errors.messages
      # # => {:base=> ["Something is required"]}
      #
      # error! name: "is required", email: "invalid"
      # errors.messages
      # # => {:name=> ["is required"], :email=> ["invalid"]}
      #
      # error! other_service.errors,
      #
      def error!(message=nil)
        if message.kind_of?  ActiveModel::Errors
          self.errors.copy! message
          self.message = message.values.join ', '
        elsif message.kind_of? Hash
          message.each do |attr, msg|
            if msg.kind_of? Array
              msg.each{|m| self.errors.add(attr, m)}
            else
              self.errors.add(attr, msg)
            end
          end
          self.message = message.values.join ', '
        else
          self.errors.add(:base, message)
          self.message = message
        end
        raise ServiceError
      end

      def error?
        !success?
      end

      def on_success
        yield self if block_given? && success?
        self
      end

      def on_error
        yield self if block_given? && error?
        self
      end

      private

      def _service_success=(result)
        @_service_success = result
      end
    end

    class_methods do
      def after_call(*filters, &blk)
        set_callback(:call, :after, *filters, &blk)
      end

      def around_call(*filters, &blk)
        set_callback(:call, :around, *filters, &blk)
      end

      def before_call(*filters, &blk)
        set_callback(:call, :before, *filters, &blk)
      end

      def after_success(*filters, &blk)
        set_callback(:success, :after, *filters, &blk)
      end

      def after_error(*filters, &blk)
        set_callback(:error, :after, *filters, &blk)
      end

      def call(*args)
        instance = self.new
        instance.run_callbacks :call do
          begin
            instance.call(*args)
            instance.send(:_service_success=, true)
            instance.run_callbacks :success
          rescue ServiceError
            instance.send(:_service_success=, false)
            instance.run_callbacks :error
          end
        end

        return instance
      end
    end

  end
end
