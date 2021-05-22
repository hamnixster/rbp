class SectionRepository < ApplicationRepository
  def initialize(item_parser)
    @item_parser = item_parser
  end

  def find(section_name)
    [""].map { |line| @item_parser.call(line) }
  end
end
