module Source
  class File < Base
    def initialize(input)
      @input = input
    end

    def call(**kwargs)
      try_touch if kwargs[:try_create]
      ::File.open(@input) if exist?
    end

    def all
      call&.read&.split("\n")&.sort&.uniq&.map(&:strip)&.reject(&:empty?) || []
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
      try_mkdir_p
      FileUtils.touch(@input)
    rescue => e
      puts e
      nil
    end

    def try_mkdir_p
      FileUtils.mkdir_p(Pathname.new(@input).dirname)
    rescue => e
      puts e
      nil
    end
  end
end
