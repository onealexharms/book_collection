HEADER_LINE = Regexp.new /^[\#][^#].*/
class BookCollection
 
  def initialize source_file
    @source_file = source_file
  end

  def file_name author_name 
    author_name.downcase.gsub(" ", "-")
  end
  
  def authors
    @source_file
      .select {|line| line.match HEADER_LINE}
      .map {|header_line| header_line[1..-1]}
  end

  def titles
    @source_file
      .select {|line| line.start_with? "["}
      .map {|book_title_line| book_title_line[1..-2]}
  end

  def images
    @source_file
      .select {|line| line.start_with? "|"}
      .map {|book_title_line| book_title_line
      .gsub("|","")
      .gsub("(","")
      .gsub(")","")
      .gsub("![]","")
      .gsub(" ","")
      }
  end

  def author_filenames
    authors.map {|author| author.downcase.gsub(" ","-")}
  end
end
