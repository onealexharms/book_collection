class BookCollection
  def initialize(source_path)
    @source_file = File.readlines(source_path)
    @the_tree = tree
  end

  attr_reader :the_tree

  def tree
    tree = {} 
    description = ''
    author = ''
    world = ''
    series = ''
    title = ''
    image = '' 
    new_image = ''
    @source_file.each do |line|
      if image? line
        image = line
        new_image = new_image_from line
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
        paths = collect_path(author, 
                              world, 
                              series, 
                              title, 
                              description,
                              image,
                              new_image) 
 
        tree[paths.first] = paths.last
        image = ''
        new_image = ''
      end
    end 
    tree
  end 

  def collect_path(author, 
                    world, 
                    series, 
                    title, 
                    description,
                    image,
                    new_image)

    base_path = (path_name_for author) + 
      (path_name_for world) + 
      (path_name_for series) + 
      (path_name_for title)

    title_path = base_path + path_name_for(title, '.md')
    unless image == ''
      image_path = path_name_for(image, '')
    end
    [base_path, [description, image_path, new_image]]
  end

  def name_from(line)
    content = line.clone
    punctuation = Regexp.new /[’\(\)\[\]\{}\#'!|:]/
    content.gsub!(punctuation, '')
    content.gsub!("\n", '')
    content.strip
  end

  def new_image_from(image)
    extension = (image.partition(".").last).partition(")").first
    "cover."+extension
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
        description = (description.concat(non_blank_line(index)).strip)
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
    line.match? /^[\#][\s](.+)/
  end

  def world?(line)
    line.match? /^[\#][\#][\s](.+)/ 
  end

  def series?(line)
    line.match? /^[\#][\#][\#][\s](.+)/ 
  end

  def image?(line)
    line.include?"![]"
  end

  def title?(line)
    line.match? /^\[.*\]/
  end
end
