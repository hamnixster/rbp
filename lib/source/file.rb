module Source
  class File < Base
    def initialize(input, hosting_section: nil)
      input = ::File.join(hosting_section&.source&.input&.dirname || "", input || "")
      @input = Pathname.new(input).cleanpath
    end

    def call(**kwargs)
      ::File.open(@input).read if exist?
    rescue => e
      ::Rbp::Container["operation.rbp.messages"] << e.message
      nil
    end

    def all
      call&.split("\n")&.sort&.uniq&.map(&:strip)&.reject(&:empty?) || []
    end

    def exist?
      @input && (path = Pathname.new(@input)) && path.exist?
    end

    def <<(line)
      if exist?
        ::File.open(@input, "a") do |f|
          f << line.strip + "\n"
        end
      end
    rescue => e
      ::Rbp::Container["operation.rbp.messages"] << e.message
      nil
    end

    def remove(line)
      if exist?
        File.open(@input, "w") do |out_file|
          File.foreach(@input) do |fl|
            out_file.puts fl unless fl == line
          end
        end
      end
    rescue => e
      ::Rbp::Container["operation.rbp.messages"] << e.message
      nil
    end

    def try_touch
      return unless try_mkdir_p
      FileUtils.touch(@input)
      ::Rbp::Container["operation.rbp.messages"] << "#{@input} is not a file" unless Pathname.new(@input).file?
      Pathname.new(@input).file?
    rescue => e
      ::Rbp::Container["operation.rbp.messages"] << e.message
      nil
    end

    def try_mkdir_p
      FileUtils.mkdir_p(Pathname.new(@input).dirname)
    rescue => e
      ::Rbp::Container["operation.rbp.messages"] << e.message
      nil
    end
  end
end
