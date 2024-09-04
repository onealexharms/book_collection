class BookCollection

  def initialize source_file_path,target_file_path
    @source_file = File.readlines(source_file_path)
    write_directories target_file_path
  end

  def write_directories target_file_path
    path = ''
    author = ''
    world = ''
    series = ''
    @source_file.each {|line|
      if is_author? line
        author = name_from line
        path = path_name_for author
      elsif is_world? line
        world = name_from line
        path = (path_name_for author) + (path_name_for world)
       elsif is_series? line
         series = name_from line
         path = (path_name_for author) + (path_name_for world) + (path_name_for series)
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

  def is_series? line
    series_line = Regexp.new /^[#][#][#]\s.*/
    line.match?(series_line)
  end
  
  def is_world? line
    world_line = Regexp.new /^[#][#]\s.*/
    line.match?(world_line)
  end

  def is_author? line
    author_line = Regexp.new /^[#][^#].*/
    line.match? author_line
  end

  def name_from line
    (line.gsub('#', '')).strip
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

  def is_world_level? line
    world_level_line = Regexp.new /^[#][#]\s/
    line.match? world_level_line
  end
  
  def is_image? line
    image_line  = Regexp.new /!\[\]\(.*\)/
    line.match? image_line 
  end

  def is_title_end? line
    line.strip.end_with? ']'
  end

  def is_title_beginning? line
    line.strip.start_with? '['
  end

  def titles 
    titles = []
    @source_file.each_with_index {|line, i|
      titles.push title(line, i) 
      }
    titles - ['']
  end

  def titles_to_paths
    titles.map {|title| path_name_for title}
  end

  def title(line, i)
    title = ''
    if is_title_beginning? line
      title = line[1..-1].strip.chomp
      until is_title_end? @source_file[i-1]
        title << ' ' << @source_file[i+1]
        i += 1
      end
    end
    title.gsub(']','').gsub("\n", '').strip
  end
end
