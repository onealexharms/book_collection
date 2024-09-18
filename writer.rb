
  def write_directories(target_file_path)
    @the_tree.keys.each do |title_directory|
      title_path = target_file_path + title_directory
      unless File.exist?(title_path)
        FileUtils.mkdir_p(title_path)
      end
    end
  end

  def write_descriptions target_file_path
    @the_tree.keys.each do |title_path|
      filename = title_path.split('/').last + ('.md')
      description_path = target_file_path + title_path + filename
      description = @the_tree[title_path][0]
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

  def write_image(source_image, target)
      if File.exist?(source_image)
        FileUtils.copy_file(source_image, target)
      else
        FileUtils.touch(target)
      end
  end
