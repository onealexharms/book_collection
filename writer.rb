require 'fileutils'
require './book_collection'

class Writer
  def initialize(tree, path)
    @target_path = path
    @collection = tree
  end

  def write
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
  
  def move_images
    @collection.keys.each do |title_path|
      image_source = @collection[title_path][1]
      if image_source
        image_name = File.basename(image_source)
        puts "image name:"
        puts image_name
        image_target_path = @target_path + title_path + image_name
        puts "image target path:"
        puts image_target_path
        if File.exist?(image_source)
          FileUtils.copy_file(image_source, image_target_path)
        end
      end
    end
  end
end
