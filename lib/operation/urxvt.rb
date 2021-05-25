module Operation
  class Urxvt < Base
    def self.register(command)
      ::Rbp::Container.register("operation.#{command}", self)
    end

    attr_reader :wrapped_operation
    def initialize(command, w: nil, **kwargs)
      @wrapped_operation = w
      @command = command
    end

    # return value here needs to indicate success/failure, should save, and next bm
    def call(bookmark, hosting_section: nil, opts: nil, wrapped: false)
      if @wrapped_operation
        @wrapped_operation.call(
          bookmark,
          hosting_section: hosting_section,
          opts: wrapped_opts(bookmark, opts),
          wrapped: true
        ) do |out, err, status, time|
          handle_output(out, err, status, time, hosting_section)
        end
      else
        final_opts = ["-e", *(opts || bookmark.input.strip)]

        now = Time.now
        out, err, status = Open3.capture3(ENV, "urxvt", *final_opts)
        time ||= Time.now - now

        if wrapped
          yield(out, err, status, time)
        else
          handle_output(out, err, status, time, hosting_section)
        end
      end
    end

    def handle_output(out, err, status, time, hosting_section)
      if status.success? && (time ||= Time.now - now) > 5
        [nil, true]
      else
        ::Rbp::Container["operation.rbp.messages"] << out
        ::Rbp::Container["operation.rbp.messages"] << err
        [hosting_section, time > 0.5]
      end
    end

    def wrapped_opts(bookmark, opts = nil)
      ["urxvt", "-e", *(opts || bookmark.input.strip)]
    end
  end
end
