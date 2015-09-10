module TimekitApi
  class Config
    @@allowed_keys = [:api_key, :input_timestamp_format, :output_timestamp_format]

    class Error < RuntimeError
    end

    attr_accessor :data
    
    def initialize
      self.reset
    end

    def update(opts)
      raise Error, 'Invalid TimeKit configuration key' if opts.keys.any?{|k| !@@allowed_keys.include?(k)}
      self.data.merge! opts
    end

    def [](key)
      self.data[key]
    end

    def []=(key, val)
      raise Error, 'Invalid TimeKit configuration key' if !@@allowed_keys.include?(key)
      self.data[key] = val
    end

    def has_key?(key)
      self.data.has_key? key
    end

    def reset
      self.data = {}
    end

  end
end