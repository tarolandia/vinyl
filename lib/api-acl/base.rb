module ACL
  
  class Configuration
    include Singleton

    @@defaults = {
      :api_acl_file => 'config/api_acl.rb',
      :api_acl_mode => 'default'
    }

    def self.defaults
      @@defaults
    end

    def intialize(options)
      @@defaults.each_pair{|k,v| self.send("#{k}=",v)}
    end


  end

  def self.config
    Configuration.instance
  end
end
