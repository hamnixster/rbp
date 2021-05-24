module Operation
  class Zsh < Base
    # return value here needs to indicate success/failure, should save, and next bm
    def call(bookmark, hosting_section: nil)
      cd = hosting_section ? "cd #{hosting_section.source.dirname};" : ""
      ENV["COMMAND"] = cd + bookmark.input
      command = "zsh -c \"$COMMAND\""
      out, err, status = Open3.capture3(command)
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
  end
end
