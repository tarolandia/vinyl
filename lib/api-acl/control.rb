module ACL
  module Control
    
    def self.put(variable)
      controller.put(variable)
      return self
    end

    def self.get(value)
      controller.variables[value]
    end

    def self.method_missing(*args)
      if args.length == 2 then #set value
        put ({args[0].to_s.chomp('=').to_sym => args[1]})
      elsif args.length == 1 #return value
        return get(args.first) || super
      else
        super
      end
    end

    def self.controller
      @access_controller ||=AccessController.new
    end

    class AccessController
      attr_reader :variables

      def initialize
        @variables = Hash.new 
      end

      def put(variable)
        @variables.merge!(variable)
      end
    end
  end
end