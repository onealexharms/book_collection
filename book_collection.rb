HEADER_LINE = Regexp.new /^[\#][^#].*/
IMAGE_LINE  = Regexp.new /!\[\]\(.*\)/

class BookCollection
 
  def initialize source_file
    @source_file = source_file
  end
  
  def authors
    @source_file
      .select {|line| line.match HEADER_LINE}
      .map {|header_line| header_line[1..-1].strip}
  end

  def titles
    @source_file
      .select {|line| line.start_with? "["}
      .map {|book_title_line| book_title_line[1..-3]}
  end

  def images
    @source_file
      .select {|line| line.match IMAGE_LINE}
      .map {|image_line| image_line
      .gsub("|", "")
      .gsub("(", "")
      .gsub(")", "")
      .gsub("![]", "")
      .strip
      }
  end
  
  def author_filenames
    authors.map {|author_name| author_name.downcase.gsub(" ", "-")}
  end
end

