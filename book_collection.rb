class BookCollection

  def initialize source_file_path,target_file_path
    source_file = File.readlines(source_file_path)
    write_directories(source_file,target_file_path)
  end

  def write_directories(source_file,target_file_path)
    path, author, world, series = '','','',''
    source_file.each_with_index {|line, line_number|
      if is_author? line
        author = name_from line
        path = path_name_for author
      elsif is_world? line
        world = name_from line
        path = (path_name_for author) + (path_name_for world)
      elsif is_series? line
        series = name_from line
        path = (path_name_for author) + (path_name_for world) + (path_name_for series)
      elsif is_title? line
        puts title(line, source_file, line_number)
      end
      path_to_write = target_file_path + path
      unless File.directory? path_to_write
        FileUtils.mkpath path_to_write
      end
    }
  end

  def path_name_for name
    punctuation = Regexp.new /[^\w]/
    name.downcase!
    dir = name.gsub(' ', '_')
    dir.gsub(punctuation, '') + '/'
  end

  def is_author? line
     line.include?('AUTHOR_')
  end

  def is_series? line
    line.include?('SERIES_')
  end
  
  def is_world? line
    line.include?('WORLD_')
  end

  def is_image? line
    line.include?('IMAGE_LINK_')
  end

  def is_title? line
    line.include?('TITLE_')
  end

  def titles_to_paths
    titles.map {|title| path_name_for title}
  end

  def titles 
    titles = []
    @source_file.each_with_index {|line, i|
      titles.push title(line, i) 
      }
    titles - ['']
  end

  def title(line, lines, line_number)
    if is_title? line
      line.gsub('TITLE_', '')
    else
      " "
    end
  end

  def name_from line
    (line.gsub!('AUTHOR_', ''))
    (line.gsub!('TITLE_', ''))
    (line.gsub!('SERIES_', ''))
    (line.gsub!('WORLD_', ''))
    line.strip
  end

=begin
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
=end

end
