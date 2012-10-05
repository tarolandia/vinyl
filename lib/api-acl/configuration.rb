module ACL
  class Configuration

    attr_accessor :force_access_control, :global_validators

    def initialize
      @force_access_control = false
      @global_validators = Array.new
    end
  end
end