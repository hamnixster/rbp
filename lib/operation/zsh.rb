module Operation
  class Zsh < Base
    # return value here needs to indicate success/failure, should save, and next bm
    def call(bookmark, hosting_section: nil)
      pre, shell = command_str(bookmark)
      out, err, status = Open3.capture3(pre.join("; ") + "; " + shell)
      ::Rbp::Container["operation.rbp.messages"] << "𝝀    : " + bookmark.input
      ::Rbp::Container["operation.rbp.messages"] << "🙟 :"
      if status.success?
        ::Rbp::Container["operation.rbp.messages"] << "  " + out.gsub(/\n/, "\n  ") + "\n"
        [hosting_section, true]
      else
        ::Rbp::Container["operation.rbp.messages"] << err
        [hosting_section, false]
      end
    end

    def command_str(bookmark)
      dirname = bookmark&.source&.dirname
      dirname ? Dir.chdir(dirname.to_s) : nil
      [
        ["zsh_command=(#{'"' + bookmark.input.strip.gsub(/\s+/, '" "') + '"'})"],
        "zsh -c ${zsh_command[*]}"
      ]
    end
  end
end
