require 'fileutils'

class BookCollection
  def initialize(source_file_path, target_file_path)
    @source_file = lines_from source_file_path 
    @the_tree = tree
    write_directories(target_file_path)
    write_images(source_file_path, target_file_path)
  end

  attr_reader :the_tree

  def write_directories(target_file_path)
    @the_tree.keys.each do |title_directory|
      title_path = target_file_path + title_directory
      unless File.exist?(title_path)
        FileUtils.mkdir_p(title_path)
      end
    end
  end

  def write_images(source_file_path, target_file_path)
    source_image_directory = File.dirname(source_file_path) + '/images/'
    @the_tree.keys.each do |title_directory|
      image_filename = 'placeholder.jpg'
      image_reference = @the_tree[title_directory][1]
      if image_reference
        unless image_reference.start_with?('http')
          image_filename = image_reference
        end
      end
      target_image_path = title_directory + image_filename
      if File.exist?(source_file_path + image_filename)
        source_path = 
          source_image_directory + image_filename
          FileUtils.copy_file(source_path, target_image_path) 
      else
          FileUtils.touch(target_image_path)
      end
    end
  end

  def lines_from source_file_path
    contents = File.read source_file_path   
    contents.gsub(/\0+/, "\n").lines
  end

  def tree
    tree = {} 
    description = ''
    author = ''
    world = ''
    series = ''
    title = ''
    image = '' 
    @source_file.each do |line|
      if image? line
        image = line
      elsif author? line  
        author = line
        world, series, title = '', '', ''
      elsif world? line
        world = line
        series, title = '', ''
      elsif series? line
        series = line
        title = ''
      elsif title? line
        title = line
        description = description_from line
        paths = collect_paths(author, 
                              world, 
                              series, 
                              title, 
                              description,
                              image) 
 
        tree[paths.first] = paths.last
        image = ''
      end 
    end 
    tree
  end 

  def collect_paths(author, 
                    world, 
                    series, 
                    title, 
                    description,
                    image)

    base_path = (path_name_for author) + 
      (path_name_for world) + 
      (path_name_for series) + 
      (path_name_for title)

    title_path = base_path + path_name_for(title, '.md')
    unless image == ''
      image_path = path_name_for(image, '')
    end
    [base_path, [description, image_path]]
  end

  def name_from(line)
    content = line.clone
    punctuation = Regexp.new '[’\(\)\[\]\{}]'
    content.gsub!('AUTHOR_', '')
    content.gsub!('TITLE_', '')
    content.gsub!('SERIES_', '')
    content.gsub!('WORLD_', '')
    content.gsub!('IMAGE_LINK_', '')
    content.gsub!(punctuation, '')
    content.gsub!("\n", '')
    content.strip
  end

  def path_name_for(line, extension = '/')
    if line && (non_blank? line)
      name = (name_from line).gsub(' ', '_')
    else 
      name = ''
      extension = ''
    end
    name + extension 
  end
  
  def description_from(line) 
    index = @source_file.find_index(line) + 1
    description = ''
    if @source_file[index]
      until @source_file[index].nil? or header?(@source_file[index])
          description = description.concat(non_blank_line(index))
          index += 1
      end
    end
    description
  end

  def non_blank_line(index)
    if non_blank? @source_file[index]
      @source_file[index]
    else
      ''
    end
  end

  def non_blank?(line)
    line.match?(/\w/) && 
      line.length() > 4
  end

  def header?(line) 
    author? line or
      series? line or
      world? line or
      image? line or
      title? line
  end

  def author?(line)
    line&.include?('AUTHOR_')
  end

  def series?(line)
    line&.include?('SERIES_')
  end

  def world?(line)
    line&.include?('WORLD_')
  end

  def image?(line)
    line&.include?('IMAGE_LINK_')
  end

  def title?(line)
    line&.include?('TITLE_')
  end
end
