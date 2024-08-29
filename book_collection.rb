class BookCollection

  def initialize source_file_path,target_file_path
    @source_file = File.readlines(source_file_path)
    @target_file_path = target_file_path
    write_directories_for author_names_to_paths
  end

  def is_author? line
    author_line = Regexp.new /^[\#][^#].*/
    line.match? author_line
  end

  def author_names
    @source_file
      .select {|line| is_author? line}
      .map {|header_line| header_line[1..-1].strip}
  end

  def author_names_to_paths
    author_names.map {|author| path_version_of author}
  end

  def path_version_of name, path=''
    path + name.downcase.gsub(" ", "-")
  end

  def write_directories_for paths
    paths&.each {|directory_name|
      path = @target_file_path + directory_name
      unless File.directory?(path)
        FileUtils.mkpath(path)
      end                
    }
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
    titles.map {|title| path_version_of title}
  end

end
