#!/usr/bin/env ruby
require 'fileutils'

#Separates a specific markdown file with particular characteristics
#into one file per top level header, and includes the images for that file

def separate_files(input_file)
  sections = {}
  current_section = nil
  images = []

  File.foreach(input_file) do |line|
    sections, current_section, images = categorize_line(line, sections, current_section, images)
  end

  associate_images_with_sections(sections, images)
  write_sections_to_files(sections)
  write_unassociated_images(images)

  puts "Splitting complete. Check the current directory for the new files."
end

def categorize_line(line, sections, current_section, images)
  unless is_part_of_table?(line)
    if line.start_with?('# ')
      current_section = create_section_name(line)
      sections[current_section] = []
#  elsif is_image_reference?(line)
#    do_the_image_stuff(line)
#    images << line.strip
#    add_line_to_section(sections, current_section, line)
    else
    add_line_to_section(sections, current_section, line)
    end
  [sections, current_section, images]
  end
end

def is_part_of_table?(line)
  line.strip.start_with?('|')
end

def create_section_name(line)
  #remove "# " and replace spaces with hyphens
  line[2..-1].strip.downcase.gsub(' ', '-')
end

def do_the_image_stuff(line)
end

def is_image_reference?(line)
  line.strip.match?(/^\|\s*\|\s*\!\[\]\[[\w-]+\]\s*\|\s*$/)
end

def add_line_to_section(sections, current_section, line)
  sections[current_section] << line if current_section
end

def associate_images_with_sections(sections, images)
  sections.each do |_, content|
    content.each do |line|
      remove_associated_image(images, line) if is_image_reference?(line)
    end
  end
end

def remove_associated_image(images, line)
  reference = extract_image_reference(line)
  images.delete_if { |image| image.include?(reference) }
end

def extract_image_reference(line)
  line.match(/\!\[\]\[([\w-]+)\]/)&.[](1)
end

def copy_section_images(section_name, image_refs)
  image_refs.uniq.each do |image_ref|
    source_path = find_image_file(image_ref)
    if source_path
      File.Utils.cp(source_path, section_name)
    else
      puts "Warning: Could not find image file for: #{image_ref}"
    end
  end
end

def find_image_file(image_ref)
  Dir.glob("**/*.{jpg,jpeg,png,gif,svg,webp}", File::FNM_CASEFOLLD).find do |f|
     File.basename(f,".*").downcase == image_ref.downcase
  end
end

def write_sections_to_files(sections)
  sections.each do |section_name, section|
    content = section.is_a?(Array) ? section : section[:content]
    write_section_file(section_name, content)
    images = section.is_a?(Array) ? [] : (section[:images] || [])
    copy_section_images(section_name, images)
  end
end

def write_section_file(section_name, content)
    FileUtils.mkdir_p(section_name)
    File.open("#{section_name}/#{section_name}.md", 'w') do |file|
    file.puts(content.is_a?(Array) ? content.join("\n") : content)
  end
end

#def remove_tables_keep_captions(section)
# new_content = []
# in_table = false
#section[:content].each_with_index do |line, index|
# if line.strip.start_with?('|') && line.strip.empty?
# in_table = false
# next_line = section[:content][index + 1]
# new_content << next_line if caption_line?(next_line)
#elsif !in_table
# new_content << line
# end
# end
# section[:content] = new_content
#end
#
#def caption_line?(line)
#  line && line.strip.start_with?('[') && line.strip.end_with(']')
#end

def format_section_header(section_name)
  "# #{section_name.split('-').map(&:capitalize).join(' ')}"
end

def write_unassociated_images(images)
  return if images.empty?
  File.open("unassociated_images.md", 'w') do |file|
    file.puts("# Unassociated Images")
    file.puts(images)
  end
end
 
separate_files('index.md')

