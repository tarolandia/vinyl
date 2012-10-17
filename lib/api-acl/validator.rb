module ACL

  def self.add_validator(name,block)
    Validators.module_eval{define_singleton_method(Validators.prefix + name,block)}
  end

  def self.add_global_validator(name,block)
    Validators.module_eval{define_singleton_method(Validators.prefix + name,block)}
    global_validators << name
  end

  def self.execute(name)
    Validators.send(Validators.prefix + name)
  end

  def self.bypass(names)
    Validators.exclude_global_validator(names)
    self
  end

  def self.global_validators
    Validators.global_validators
  end

  module Validators
    
    @@prefix = "validator_"#use prefixs to avoid collisions betweeen variables and methods names
    @@exclusion_list = []
    
    def self.prefix
      @@prefix
    end
    
    def self.global_validators
      @@global_validators ||= Array.new
    end

    def self.exclude_global_validator(name)
      name = ["#{name}"] if name.instance_of? String
      @@exclusion_list |= name
    end


    def self.clean_exclusion_list
      @@exclusion_list = Array.new
    end

    def self.run_validators(validators)
      validators = validators + (ACL.global_validators - @@exclusion_list)
      clean_exclusion_list
      if validators.nil? || validators.empty? then
        return !ACL.config.force_access_control
      end
      validators.each do |method_name|
        pass = ACL::Validators.send(prefix + method_name)
        if(pass == false) then
          return false
        end
      end
      return true
    end

    def self.method_missing(*args) #Return false if no validator exists
      if (ACL::controller.variables.include?(args[0])) then
        return ACL::get(args[0])
      else
        STDOUT.puts "Warning: missing method #{args[0]}, Validator defaults to false" if ACL.config.warn_on_missing_validators
        return false
      end
    end
  end
end
