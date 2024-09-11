require 'fileutils'

class BookCollection
  def initialize(source_file_path, target_file_path)
    @source_file = File.readlines source_file_path
    @target = target_file_path
    @the_tree = tree
    puts tree
  end

  attr_reader :the_tree

  def populate_tree
    @the_tree.each_with_index {|path, i|
    if is_title?(path)
      title = name_from line
      puts 'title: ' + title
      new_path = 
        (path_name_for author) + 
        (path_name_for world) + 
        (path_name_for series) + 
        (path_name_for title)
    elsif is_image?(path)
      image = name_from line
      puts 'image', (image) 
      new_path
    end
    }
  end
  
  def write_tree
    @the_tree.each_with_index { |path, index|
      target_path = @target + path
      if line_is_a_directory? target_path
        FileUtils.mkdir_p target_path unless there_is_already_a_directory? path
      end
      text_line = index + 1
      until line_is_an_image? @the_tree[text_line]
        text = ''
        text << @the_tree[text_line]
        text_line += 1
      end
    }
  end

  def line_is_an_image?(line)
    if not (line.nil? or line == '')
    else
      line.end_with?('.jpg', '.jpeg', '.JPEG', '.webp')
    end
  end

  def line_is_a_file_name?(line)
    line && line.end_with?('.md', '.jpg', '.jpeg', '.JPEG', '.webp')
  end

  def line_is_a_directory?(line)
    !line_is_a_file_name? line
  end

  def there_is_already_a_directory_or_file?(path)
    File.exist? path
  end

  def tree
    tree = []
    path, author, world, series, title, image = '', '', '', '', '', ''
    @source_file.each { |line|
      if is_blank?(line)
      elsif is_author?(line)  
        author = name_from line
        world, series, title = '', '', ''
 
      elsif is_world?(line)
        world = name_from line
        series, title = '', ''

      elsif is_series?(line)
        series = name_from line
        title = ''
 
      elsif is_image?(line)
        files_for (line)
        path = 
          (path_name_for author) +
          (path_name_for world) +
          (path_name_for series) +
          (path_name_for title)
          tree << path
      end
    }
    tree
  end

  def name_from(line)
    punctuation = Regexp.new '[’\(\)\[\]\{}]'
    line.gsub!('AUTHOR_', '')
    line.gsub!('TITLE_', '')
    line.gsub!('SERIES_', '')
    line.gsub!('WORLD_', '')
    line.gsub!('IMAGE_LINK_', '')
    line.gsub!(punctuation, '')
    line.strip
  end

  def path_name_for(name, extension = '/')
    if name > ''
      punctuation = Regexp.new '[’\(\)\[\]\{}]'
      name.gsub!(' ', '_')
      name.gsub!(punctuation, '')
      name + extension
    else
      ''
    end
  end

  def files_for line
    i = @source_file.find_index line 
    title = title_from i
    description = description_from i
  end
  
  def title_from i
    lines = @source_file[i..-1] 
    lines.each do |line|
      if is_title? line
        title = name_from line 
      end
      return title
    end
  end

  def description_from i
  ''         
  end

  def is_blank? line
    not line.match? /\w/
  end

  def is_a_header? line 
    is_author? line or  
      is_series? line or 
      is_world? line
  end

  def is_author?(line)
    line.include?('AUTHOR_')
  end

  def is_series?(line)
    line.include?('SERIES_')
  end

  def is_world?(line)
    line.include?('WORLD_')
  end

  def is_image?(line)
    line.include?('IMAGE_LINK_')
  end

  def is_title?(line)
    line.include?('TITLE_')
  end
end
