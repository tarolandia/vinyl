module ACL
  module Rules
    module Collection
      
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        @@acl_routes_collection = {}

        def when_route(route, *args) 
          method = args[0][:with_method]
          access_level = args[0][:get_access_level]
          validators = args[0][:if_pass]
          @@acl_routes_collection[route] ||= Hash.new
          @@acl_routes_collection[route][method] ||= Hash.new
          @@acl_routes_collection[route][method][access_level] = validators
        end

        def acl_routes_collection
          @@acl_routes_collection
        end
      end
    end
  end
end
