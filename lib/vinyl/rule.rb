module Vinyl

  def self.when_route(route, *args)
    Rule.add(route, args[0])
  end

  def self.acl_routes_collection
    Rule.acl_routes_collection
  end

  class Rule

    class RegExpHash < Hash
      def [](a)
        return super a if a.class == Regexp
        self.keys.each do |pattern|
          return super pattern if a.respond_to?(:match) && a.match(pattern)
        end
        return nil
      end
    end

    @@acl_routes_collection = RegExpHash.new

    def self.add(route, *args) 
      begin
        method = args[0][:with_method]
        access_level = args[0][:get_access_level]
        validators = args[0][:if_pass]
        if(route.to_s.empty? || method.empty? || access_level.to_s.empty?) then
          raise InvalidAclRule, "Vinyl.rule is invalid"
        end
      rescue NoMethodError => e
        raise InvalidAclRule, "Vinyl.rule is invalid"
      rescue InvalidAclRule => e
        puts e.message
        puts e.backtrace
      end
      pattern = generate_pattern(route)
      @@acl_routes_collection[method] ||= RegExpHash.new
      @@acl_routes_collection[method][pattern] ||= Hash.new
      @@acl_routes_collection[method][pattern][access_level] = validators
    end

    #The ideas for this method were extracted from Sinatra's source
    #https://github.com/sinatra/sinatra/blob/master/lib/sinatra/base.rb
    #Copyright (c) 2007, 2008, 2009, 2010, 2011 Blake Mizerany
    def self.generate_pattern(path)
      if path.respond_to? :to_str
        ignore = ""
        pattern = path.to_str.gsub(/[^\?\%\\\/\:\*\w]/) do |c|
          ignore << escaped(c).join if c.match(/[\.@]/)
          encoded(c)
        end
        pattern.gsub!(/((:\w+)|\*)/) do |match|
          if match == "*"
            "(.*?)"
          else
            "([^#{ignore}/?#]+)"
          end
        end
        /\A#{pattern}\z/
      elsif path.respond_to?(:keys) && path.respond_to?(:match)
        path
      elsif path.respond_to?(:names) && path.respond_to?(:match)
        path
      elsif path.respond_to? :match
        path
      else
        raise TypeError, path
      end
    end

    def self.escaped(char, enc = URI.escape(char))
      [Regexp.escape(enc), URI.escape(char, /./)]
    end

    def self.encoded(char)
      enc = URI.escape(char)
      enc = "(?:#{escaped(char, enc).join('|')})" if enc == char
      enc = "(?:#{enc}|#{encoded('+')})" if char == " "
      enc
    end

    def self.acl_routes_collection
        @@acl_routes_collection
    end
  end

  class InvalidAclRule < StandardError; end
end
