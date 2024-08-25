HEADER_LINE = Regexp.new /^[\#][^#].*/
class BookCollection

  def initialize source_file
    @source_file = source_file
  end

  def authors
    @source_file
      .select {|line| line.match(HEADER_LINE) }
      .map {|header_line| header_line[1..-1]}
  end
end
