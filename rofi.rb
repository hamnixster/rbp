class Rofi
  def call(prompt, lines)
    opts = {
      "-dmenu" => "",
      "-p" => prompt,
      "-theme" => THEME
    }.reject { |_, v| v.nil? }.to_a.flatten.reject(&:empty?)
    selection = Open3.popen2(ENV, "rofi", *opts) { |stdin, stdout|
      lines.each { |l| stdin.puts(l) }
      stdin.close
      stdout.read
    }
    selection.strip
  end
end
