require 'fileutils'

class BookCollection
  attr_accessor :the_tree

  def initialize source_file_path,target_file_path
    @source_file = File.readlines source_file_path
    @target = target_file_path
    @the_tree = tree
    write_tree
  end

  def write_tree
    @the_tree.each_with_index {|line, index| 
      path = @target + line
      if line_is_a_directory? line 
        unless there_is_already_a_directory? path
          FileUtils.mkdir_p path
        end
      else
        until line_is_a_file_name? @the_tree[index]
          puts @the_tree[index]
          index += 1
        end
#        end
#        File.open(path, 'w')
#        File.close
      end
    }
  end
  
  def line_is_a_file_name? line
    line.end_with?('.md', '.jpg', '.jpeg', '.JPEG', '.webp')
  end

  def line_is_a_directory? line
    not line_is_a_file_name? line
  end

  def there_is_already_a_directory? path
    Dir.exist? path
  end

  def tree
    the_tree = []
    path, author, world, series, title, image = '','','','','',''
    @source_file.each_with_index {|line, line_number|
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
      elsif is_image? line
        image = name_from line
      elsif is_title? line
        title = name_from line
        path = (path_name_for author)+(path_name_for world)+(path_name_for series)+(path_name_for title)
        the_tree << path + (path_name_for title, '.md')
        the_tree << path + image.gsub(/(\(|\))/,'')
      end
    }
    the_tree
  end

  def name_from line
    (line.gsub!('AUTHOR_', ''))
    (line.gsub!('TITLE_', ''))
    (line.gsub!('SERIES_', ''))
    (line.gsub!('WORLD_', ''))
    (line.gsub!('IMAGE_LINK_', ''))
    line.strip
  end

  def path_name_for name, extension = '/'
    if name>'' 
      punctuation = Regexp.new /[\’\(\),\[\]\{\}]/
      name.downcase!
      name.gsub!(' ', '_')
      name.gsub!(punctuation, '')
      name + extension
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
end
