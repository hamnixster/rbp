MARKS = {"main" => []}

def main(section)
  command = yield(section, MARKS[section])
end
