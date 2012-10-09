module ACL
  module Control
    
    def self.check_level(route,method)
      validators_collection = Rules::Collection::ClassMethods.acl_routes_collection[route][method]
      if validators_collection.nil? || validators_collection.empty? then
        return 0
      end
      keys = validators_collection.keys.sort
      highest_level = 0
      keys.reverse_each do |access_level|
        pass = ACL::Validators.run_validators(validators_collection[access_level])
        if (pass==true)
          highest_level = access_level
          break
        end
      end
      return highest_level
    end

    def self.put(variable)
      controller.put(variable)
      return self
    end

    def self.get(value)
      controller.variables[value]
    end

    def self.controller
      @access_controller ||=AccessController.new
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