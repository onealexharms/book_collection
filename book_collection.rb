require './writer'

class BookCollection
  def initialize(source_file)
    @image_source = image_path_from source_file
    @lines = File.readlines(source_file)
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
    @lines.each do |line|
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
        paths = collect_path(author,
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

  def collect_path(author,
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
      image_path = @image_source + path_name_for(image, '')
    end
    [base_path, [description, image_path]]
  end

  def image_path_from source_file
    parts = source_file.split('/')
    parts.reject! {|part| part == File.basename(source_file)}
    parts.join('/') + '/images/'
  end

  def name_from(line)
    content = line.clone
    punctuation = Regexp.new /[’\(\)\[\]\{}\#'!|:]/
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
    index = @lines.find_index(line) + 1
    description = ''
    if @lines[index]
      until @lines[index].nil? or header?(@lines[index])
        description = (description.concat(non_blank_line(index)).strip)
          index += 1
      end
    end
    description
  end

  def non_blank_line(index)
    if non_blank? @lines[index]
      @lines[index]
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
