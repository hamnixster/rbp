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
      pre, shell = command_str(bookmark)
      out, err, status = Open3.capture3(pre.join("; ") + "; " + shell)
      if status.success?
        [nil, true]
      else
        ::Rbp::Container["operation.rbp.messages"] << err
        [hosting_section, false]
      end
    end

    def command_str(bookmark)
      dirname = bookmark&.source&.dirname
      dirname ? Dir.chdir(dirname.to_s) : nil

      if @wrapped_operation
        wrapper_pre, wrapper_command = @wrapped_operation.command_str(bookmark)
        [
          wrapper_pre.concat(
            ["urxvt_command=(#{'"' + wrapper_command.split(" ")[...-1].join("\" \"") + '"'})"]
          ),
          "urxvt -e ${urxvt_command[*]} \"${#{wrapper_pre[-2].split("=").first}[*]}\""
        ]
      else
        [
          ["urxvt_command=(#{'"' + bookmark.input.strip.gsub(/\s+/, '" "') + '"'})"],
          "urxvt -e ${urxvt_command[*]}"
        ]
      end
    end
  end
end
