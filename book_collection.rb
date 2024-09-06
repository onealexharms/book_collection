require 'fileutils'

class BookCollection
  attr_accessor :the_tree

  def initialize source_file_path,target_file_path
    source_file = (File.readlines source_file_path)
    @the_tree = tree(source_file,target_file_path)
    write(@the_tree, target_file_path)
  end

  def write(tree, target_file_path)
    tree.each {|line| 
      path = target_file_path + line
      unless File.exist? path
        FileUtils.mkdir_p path
        if line.end_with? ".md"
        FileUtils.touch(path)
        end
      end
    }
  end

  def tree(source_file,target_file_path)
    the_tree = []
    path, author, world, series, title, image = '','','','','',''
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
      elsif is_image? line
        image = name_from line
      elsif is_title? line
        title = name_from line
        path = (path_name_for author)+(path_name_for world)+(path_name_for series)+(path_name_for title)
        the_tree << path + (path_name_for title, '.md')
        the_tree << path + (image_file_name_for image)
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

  def image_file_name_for name
    punctuation = Regexp.new /(\(|\))/
    name.gsub!(punctuation, '')
    name
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
