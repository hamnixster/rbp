module Operation
  class Asdf < Base
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
          opts: wrapped_opts(bookmark, opts, wrapped: true)
        ) do |out, err, status, time|
          if block_given?
            yield(out, err, status, time, hosting_section, bookmark)
          else
            handle_output(out, err, status, time, hosting_section, bookmark)
          end
        end
      else
        Operation::Zsh.new(@command).call(
          bookmark,
          hosting_section: hosting_section,
          opts: wrapped_opts(bookmark, opts),
          wrapped: wrapped
        ) do |out, err, status, time|
          if block_given?
            yield(out, err, status, time, hosting_section, bookmark)
          else
            handle_output(out, err, status, time, hosting_section, bookmark)
          end
        end
      end
    end

    def wrapped_opts(bookmark, opts = nil, wrapped: false)
      if wrapped
        Operation::Zsh.new(@command).wrapped_opts(
          bookmark,
          ["asdf", "exec", (opts || [bookmark.input.strip]).join(" ")],
          wrapped: true
        )
      else
        ["asdf", "exec", (opts || [bookmark.input.strip]).join(" ")]
      end
    end

    private

    def run_command(opts, bookmark)
      final_opts = ["asdf", "exec", *(opts || bookmark.input.strip.split(" "))]

      now = Time.now
      out, err, status = Open3.capture3(ENV, "asdf", *final_opts)
      time ||= Time.now - now
      [out, err, status, time]
    end

    def handle_output(out, err, status, time, hosting_section, bookmark)
      ::Rbp::Container["operation.rbp.messages"] << "𝝀    : " + bookmark.input
      ::Rbp::Container["operation.rbp.messages"] << "🙟 :"
      ::Rbp::Container["operation.rbp.messages"] << "  " + out.gsub(/\n/, "\n  ").delete("<").delete(">") + "\n"
      ::Rbp::Container["operation.rbp.messages"] << "\n\n"
      ::Rbp::Container["operation.rbp.messages"] << "  " + err.gsub(/\n/, "\n  ").delete("<").delete(">") + "\n"
      if status.success?
        [hosting_section, true]
      else
        [hosting_section, time > 0.5]
      end
    end
  end
end
