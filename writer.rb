require 'fileutils'
require './book_collection'

class Writer
  def initialize()
    @target_path = "./data/books/"
    book_collection = BookCollection.new('./data/index.md')
    @collection = book_collection.the_tree
    write_directories
    write_descriptions
    move_images
  end

  def write_directories
    @collection.keys.each do |title_directory|
      title_path = @target_path + title_directory
      unless File.exist?(title_path)
        FileUtils.mkdir_p(title_path)
      end
    end
  end

  def write_descriptions 
    @collection.keys.each do |title_path|
      filename = title_path.split('/').last + ('.md')
      description_path = @target_path + title_path + filename
      description = @collection[title_path][0]
      IO.write(description_path, description)
    end
  end

  def image_filename_for image_reference
    if image_reference
      if image_reference.start_with?('http')
        image_filename = 'placeholder.jpg'
      else
        image_filename = image_reference
      end
    else
      image_filename= 'placeholder.jpg'
    end
  end

  def move_images
    @collection.keys.each do |title_path|
      image = image_filename_for(@collection[title_path][1])
      source = './data/images/' + image
      image_path = @target_path + title_path + image 
      if File.exist?(source)
        FileUtils.copy_file(source, image_path)
      else
        FileUtils.touch(image_path)
      end
    end
  end

  writer = Writer.new
end
