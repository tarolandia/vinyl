module ACL

  @@prefix = "validator_"#use prefixs to avoid collisions betweeen variables and methods names

  def self.add_validator(name,block)
    Validators.module_eval{define_singleton_method(@@prefix + name,block)}
  end

  def self.add_global_validator(name,block)
    Validators.module_eval{define_singleton_method(@@prefix + name,block)}
    global_validators << name
  end

  def self.execute(name)
    Validators.send(@@prefix + name)
  end

  def self.prefix
    @@prefix
  end

  def self.global_validators
    @@global_validators ||= Array.new
  end

  module Validators

    def self.run_validators(validators)
      validators.concat(ACL.global_validators)
      if validators.nil? || validators.empty? then
        return true
      end
      validators.each do |method_name|
        pass = ACL::Validators.send(ACL.prefix + method_name)
        if(pass == false) then
          return false
        end
      end
      return true
    end

    def self.method_missing(*args) #Return false if no validator exists
      user_variable = ACL::get(args[0])
      if(user_variable.nil?) then
        STDOUT.puts "Warning: missing method #{args[0]}, Validator defaults to false"
        return false
      else
        return user_variable
      end
    end
  end
end