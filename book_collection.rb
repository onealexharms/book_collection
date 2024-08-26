class BookCollection
 
  def initialize source_file
    @source_file = source_file
  end
  
  def is_author? line
    author_line = Regexp.new /^[\#][^#].*/
    line.match? author_line
  end

  def authors
    @source_file
      .select {|line| is_author? line}
      .map {|header_line| header_line[1..-1].strip}
  end

  def is_title? line
    line.start_with? "["
  end

  def titles
    @source_file
      .select {|line| is_title? line}
      .map {|book_title_line| book_title_line[1..-3]}
  end

  def is_image? line
    image_line  = Regexp.new /!\[\]\(.*\)/
    line.match image_line 
  end

  def images
    @source_file
      .select {|line| is_image? line}
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

