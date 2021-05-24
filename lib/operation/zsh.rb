module Operation
  class Zsh < Base
    # return value here needs to indicate success/failure, should save, and next bm
    def call(bookmark, hosting_section: nil)
      out, err, status = Open3.capture3("zsh", "-c", *bookmark.input.strip)
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

    def wrapped_opts(bookmark, opts)
      [opts.first, "zsh", "-c", *bookmark.input.strip].each { |opt| opts << opt }
    end
  end
end
