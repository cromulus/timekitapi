module TimekitApi
  class Config
    VALID_OPTIONS_KEYS = [:api_key,
                          :default_timezone,
                          :app_name,
                          :input_timestamp_format,
                          :output_timestamp_format,
                          :debug].freeze

    class Error < RuntimeError
    end

    attr_accessor :data

    def initialize
      reset
    end

    def update(opts)
      fail Error, 'Invalid TimeKit configuration key' if opts.keys.any? { |k| !VALID_OPTIONS_KEYS.include?(k) }
      data.merge! opts
    end

    def [](key)
      data[key]
    end

    def []=(key, val)
      fail Error, 'Invalid TimeKit configuration key' unless VALID_OPTIONS_KEYS.include?(key)
      data[key] = val
    end

    def has_key?(key)
      data.key? key
    end

    def reset
      self.data = { debug:                   false,
                    timezone:                Time.now.zone,
                    input_timestamp_format:  'Y-m-d h:ia',
                    output_timestamp_format: 'Y-m-d h:ia'
                  }
    end
  end
end