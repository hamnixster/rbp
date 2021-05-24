module Operation
  class Urxvt < Base
    def self.register(command)
      ::Rbp::Container.register("operation.#{command}", self)
    end

    def initialize(command, w: nil, **kwargs)
      @wrapped_operation = w
      @command = command
    end

    # return value here needs to indicate success/failure, should save, and next bm
    def call(bookmark, hosting_section: nil)
      opts = ["-e", *bookmark.input.strip]
      opts = @wrapped_operation&.wrapped_opts(bookmark, opts) || opts

      now = Time.now
      out, err, status = Open3.capture3(ENV, "urxvt", *opts)

      # if the program is open for less than 5 seconds, reopen the host
      if status.success? && (time = Time.now - now) > 5
        [nil, true]
      else
        ::Rbp::Container["operation.rbp.messages"] << out
        ::Rbp::Container["operation.rbp.messages"] << err
        [hosting_section, time > 0.5]
      end
    end
  end
end
