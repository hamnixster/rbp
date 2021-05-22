module Source
  class File < Base
    def call(**kwargs)
      try_touch if kwargs[:try_create]
      ::File.open(@input) if exist?
    end

    def all
      call&.read&.split("\n") || []
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
    end

    def try_touch
      FileUtils.touch(@input)
    rescue Errno::ENOENT
      nil
    end
  end
end
