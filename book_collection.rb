class BookCollection
  attr_accessor :the_tree

  def initialize source_file_path,target_file_path
    source_file = File.readlines(source_file_path)
    the_tree = write_directories(source_file,target_file_path)
  end

  def write_directories(source_file,target_file_path)
    @the_tree = []
    path, author, world, series, title = '','','','',''
    source_file.each_with_index {|line, line_number|
      if is_author? line
        author = name_from line
        path = path_name_for author
        world, series, title = '','',''
        the_tree << path
      elsif is_world? line
        world = name_from line
        path = (path_name_for author) + (path_name_for world)
        series, title = '',''
        the_tree << path
      elsif is_series? line
        series = name_from line
        path = (path_name_for author) + (path_name_for world) + (path_name_for series)
        title = ''
        the_tree << path
      elsif is_title? line
        title = name_from line
        path = (path_name_for author)+(path_name_for world)+(path_name_for series)+(path_name_for title)
        the_tree << path + (file_name_for title)
      end
    }
    puts the_tree
end

  def file_name_for name
    punctuation = Regexp.new /[^\w]/
    name.downcase!
    name.gsub!(' ', '_')
    name.gsub!(punctuation, '')
    name + '.md'
  end

  def path_name_for name
    if name>'' 
      punctuation = Regexp.new /[^\w]/
      name.downcase!
      name.gsub!(' ', '_')
      name.gsub!(punctuation, '')
      name + '/'
    else
      ''
    end
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
