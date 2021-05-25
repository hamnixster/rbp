module Operation
  class Zsh < Base
    def self.register(command)
      ::Rbp::Container.register("operation.#{command}", self)
    end

    def initialize(command, w: nil, **kwargs)
      @wrapped_operation = w
      @command = command
    end

    def call(bookmark, hosting_section: nil, opts: nil, wrapped: false)
      if @wrapped_operation
        @wrapped_operation.call(
          bookmark,
          hosting_section: hosting_section,
          opts: wrapped_opts(bookmark)
        ) do |out, err, status, time|
          if block_given?
            yield(out, err, status, time, hosting_section, bookmark)
          else
            handle_output(out, err, status, time, hosting_section, bookmark)
          end
        end
      else
        out, err, status, time = run_command(opts, bookmark)
        if wrapped
          yield(out, err, status, time)
        else
          if block_given?
            yield(out, err, status, time, hosting_section, bookmark)
          else
            handle_output(out, err, status, time, hosting_section, bookmark)
          end
        end
      end
    end

    def handle_output(out, err, status, time, hosting_section, bookmark)
      if status.success? && !out.empty?
        ::Rbp::Container["operation.rbp.messages"] << "𝝀    : " + bookmark.input
        ::Rbp::Container["operation.rbp.messages"] << "🙟 :"
        ::Rbp::Container["operation.rbp.messages"] << "  " + out.gsub(/\n/, "\n  ").delete("<").delete(">") + "\n"
        [hosting_section, true]
      elsif status.success?
        [hosting_section, true]
      else
        ::Rbp::Container["operation.rbp.messages"] << err.delete("<").delete(">")
        [hosting_section, false]
      end
    end

    def wrapped_opts(bookmark, opts = nil, wrapped: false)
      ["zsh", "-c", (opts || [bookmark.input.strip]).join(" ") + "; $SHELL"]
    end

    private

    def run_command(opts, bookmark)
      ENV["ZSH_COMMAND"] = (opts || [bookmark.input.strip]).join(" ")
      final_opts = ["-c", "eval \"$ZSH_COMMAND\""]

      now = Time.now
      out, err, status = Open3.capture3(ENV, "zsh", *final_opts)
      time ||= Time.now - now
      [out, err, status, time]
    end
  end
end
