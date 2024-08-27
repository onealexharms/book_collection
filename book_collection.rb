class BookCollection
 
  def initialize source_file_path,target_file_path
    @source_file = File.readlines(source_file_path)
    @target_file_path = target_file_path
    write_author_directories
  end
  
  def write_author_directories
    author_names_to_directories.each {|directory_name|
      path = @target_file_path + directory_name
      unless File.directory?(path)
        FileUtils.mkpath(path)
      end                
    }
  end

  def author_names
    @source_file
      .select {|line| is_author? line}
      .map {|header_line| header_line[1..-1].strip}
  end

  def directory_name_for author_name
    author_name.downcase.gsub(" ", "-")
  end

  def author_names_to_directories
    author_names.map {|author| directory_name_for author}
  end
  
  def image_filenames
    @source_file
      .select {|line| is_image? line}
      .map {|image_line| 
        image_line_to_filename image_line
      }
  end

  def image_line_to_filename image_line
    image_line
      .gsub("|", "")
      .gsub("(", "")
      .gsub(")", "")
      .gsub("![]", "")
      .strip
  end

  def titles
    @source_file
      .select {|line| is_title? line}
      .map {|book_title_line| book_title_line[1..-3]}
  end

  def is_author? line
    author_line = Regexp.new /^[\#][^#].*/
    line.match? author_line
  end

  def is_image? line
    image_line  = Regexp.new /!\[\]\(.*\)/
    line.match image_line 
  end

  def is_title? line
    line.start_with? "["
  end
end

