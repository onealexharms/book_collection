require 'fileutils'

class BookCollection
  def initialize(source_file_path, target_file_path)
    @source_file = File.readlines source_file_path
    @target = target_file_path
    @the_tree = tree
  end

  attr_reader :the_tree

  def populate_tree
    @the_tree.each_with_index {|path, i|
    if is_title?(path)
      title = name_from line
      puts 'title', title
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
    if line.nil? or line == ''
      ''
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
    @source_file.each_with_index { |line, _line_number|
      if is_author?(line)  
        author = name_from line
        path = path_name_for author
        world, series, title = '', '', ''
        tree << path 
      elsif is_world?(line)
        world = name_from line
        path = (path_name_for author) + 
          (path_name_for world)
        series, title = '', ''
        tree << path 
      elsif is_series?(line)
        series = name_from line
        path = 
          (path_name_for author) + 
          (path_name_for world) + 
          (path_name_for series)
        title = ''
        tree << path 
      end
    }
    puts "======================================="
    puts tree
    
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
