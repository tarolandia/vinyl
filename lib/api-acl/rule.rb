module ACL

  def self.when_route(route, *args)
    Rule.new(route, args[0])
  end

  def self.acl_routes_collection
    Rule.acl_routes_collection
  end

  class Rule
    @@acl_routes_collection = {}

    def initialize(route, *args) 
      begin
        method = args[0][:with_method]
        access_level = args[0][:get_access_level]
        validators = args[0][:if_pass]
        if(route.empty? || method.empty? || access_level.to_s.empty?)
          raise InvalidAclRule, "ACL rule is invalid"
        end
      rescue NoMethodError => e
        raise InvalidAclRule, "ACL rule is invalid"
      rescue InvalidAclRule => e
        puts e.message
        puts e.backtrace
      end
      @@acl_routes_collection[route] ||= Hash.new
      @@acl_routes_collection[route][method] ||= Hash.new
      @@acl_routes_collection[route][method][access_level] = validators
    end

    def self.acl_routes_collection
      @@acl_routes_collection
    end
  end

  class InvalidAclRule < StandardError; end
end