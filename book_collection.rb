require 'fileutils'

# why is the test failing
# why does the tree contain images
# what do I do with the nulls and the \n in this data grrr 
# how do I get a trace (or how to use logger but I'd rather just have a trace)
# does there have to be a difference between returns and evaluates to?
class BookCollection
  def initialize(source_file_path, target_file_path)
    @source_file = File.readlines source_file_path
    @target = target_file_path
    @the_tree = tree
  end

  attr_reader :the_tree

  def tree
    tree = []
    path = []
    description = ''
    author = ''
    world = ''
    series = ''
    title = ''
    image = ''
    @source_file.each do |line|
      puts "=========="
      puts line
      if image? line
        puts "image"
        line = ''
      elsif author?(line)  
        puts "author"
        author = line
        world, series, title = '', '', ''
      elsif world?(line)
        puts "world"
        world = line
        series, title = '', ''
      elsif series?(line)
        puts "series"
        series = line
        title = ''
      elsif title?(line)
        puts "title"
        title = line
        path = [(path_name_for author) + 
          (path_name_for world) + 
          (path_name_for series) + 
          (path_name_for title)] 
        path <<  [(description_from line)]
        path
      end
    end
  end

  def name_from(line)
    puts "name_from " + line
    punctuation = Regexp.new '[’\(\)\[\]\{}]'
    line.gsub!('AUTHOR_', '')
    line.gsub!('TITLE_', '')
    line.gsub!('SERIES_', '')
    line.gsub!('WORLD_', '')
    line.gsub!('IMAGE_LINK_', '')
    line.gsub!(punctuation, '')
    line.gsub!("\n", '')
    line.strip
  end

  def path_name_for(line, extension = '/')
    if non_blank? line
      name = (name_from line).gsub(' ', '_')
      puts "path_name_for line is " + name + extension
      name + extension 
    else 
      ''
    end
  end
  
  def description_from(line) 
    index = @source_file.find_index(line) + 1
    description = ''
    if @source_file[index] && not_a_header?(@source_file[index])
      description.concat non_blank_line(index)
      index += 1
    end
    description
    end

  def non_blank_line(index)
    if non_blank? @source_file[index]
      @source_file[index]
    end
  end

  def non_blank?(line)
    line.match?(/\w/) && 
      line.length() > 4
  end

  def not_a_header?(line) 
    author? line or
      series? line or
      world? line or
      image? line or
      title? line
  end

  def author?(line)
    line.include?('AUTHOR_')
  end

  def series?(line)
    line.include?('SERIES_')
  end

  def world?(line)
    line.include?('WORLD_')
  end

  def image?(line)
    line.include?('IMAGE_LINK_')
  end

  def title?(line)
    line.include?('TITLE_')
  end
end
