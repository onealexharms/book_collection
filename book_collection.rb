class BookCollection

  def initialize source_file_path,target_file_path
    @source_file = File.readlines(source_file_path)
    @target_file_path = target_file_path
    write_directories
  end

  def write_directories
    path_to_write = ''
    current_author_directory = ''
    @source_file.each {|line|
      if is_author? line
        current_author_directory = path_name_for (name_from line)
        path_to_write = path_name_for @target_file_path, (name_from line)
      elsif is_world? line
        path_to_write = path_name_for (@target_file_path + current_author_directory), (name_from line) 
      end
      unless File.directory?(path_to_write)
        FileUtils.mkpath(path_to_write)
      end                
    }
  end

  def path_name_for path='', name
    punctuation = Regexp.new /[^\w]/
    name.downcase!
    dir = name.gsub(' ', '_')
    path + dir.gsub(punctuation, '') + '/'
  end
  
  def is_world? line
    world_line = Regexp.new /^[#][#]\s.*/
    line.match?(world_line)
  end

  def is_author? line
    author_line = Regexp.new /^[\#][^#].*/
    line.match? author_line
  end

  def world_name line
    line[2..-1].strip
  end

  def author_name line
      line[1..-1].strip
  end

  def name_from line
    (line.gsub('#', '')).strip
  end

  def author_names
    @source_file
      .select {|line| is_author? line}
      .map {|line| author_name line}
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
