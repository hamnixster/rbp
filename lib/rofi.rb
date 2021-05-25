class Rofi
  def self.call(prompt, lines, theme: THEME, mesg: nil)
    opts = {
      "-dmenu" => "",
      "-p" => prompt,
      "-mesg" => mesg,
      "-theme" => theme
    }.reject { |_, v| v.nil? }.to_a.flatten.reject(&:empty?)

    selection = Open3.popen2(ENV, "rofi", *opts) { |stdin, stdout|
      lines.each { |l| stdin.puts(l.to_s.strip) }
      stdin.close
      stdout.read
    }
    selection.strip
  end
end
