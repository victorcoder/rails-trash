module Trash

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods

    ##
    #   class Entry < ActiveRecord::Base
    #     enable_trash
    #   end
    #
    def enable_trash
      extend ClassMethodsMixin
      include InstanceMethods
    end

    module ClassMethodsMixin

      def deleted
        unscoped.where("#{self.table_name}.deleted_at IS NOT NULL")
      end

    end

    module InstanceMethods

      def destroy
        self.update_attribute(:deleted_at, Time.now.utc)
      end

    end

  end
end

ActiveRecord::Base.send :include, Trash