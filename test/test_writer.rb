$LOAD_PATH.unshift File.expand_path('..', __dir__)
require 'writer'
require 'book_collection'
require 'minitest/autorun'
require 'minitest/pride'
require 'fileutils'

module Minitest::Expectations
  def look_for file
    if File.exist? file
      'found'
    else
      'not found: ' + file
    end
  end
end

class TestWriter < Minitest::Spec

  before do
    source_file = "test/test_data/mini_index.md"
    @tree = BookCollection.new(source_file).the_tree

    @target_path = "test/test_data/results/"
    FileUtils.rm_rf @target_path
    Dir.mkdir @target_path
    @writer = Writer.new(@tree, @target_path)
  end

  describe Writer do
    it 'has a tree' do
      _(@tree.keys.first).must_equal "Ada_Palmer/Terra_Ignota/Too_Like_the_Lightning/"
    end

    it 'writes directories' do
      @writer.write_directories
      path = @target_path + "Ada_Palmer/Terra_Ignota/Too_Like_the_Lightning/"
      _(Dir.exist? path).must_equal true

    end

    it 'writes descriptions' do
      @writer.write
      description = @target_path + "William_Gibson/Sprawl_Trilogy/Neuromancer/Neuromancer.md"
      _(File.exist? description).must_equal true
      _(File.readlines(description).first).must_include "Case was the sharpest."
    end

    it 'moves images' do
      @writer.write
      book_path = @target_path + 'Ada_Palmer/Terra_Ignota/Too_Like_the_Lightning/'
      image = book_path + '1_too_like_the_lightning.jpg'
      _(look_for image).must_equal ('found')
      _(look_for (image + 'blergh')).must_equal ('not found: ' + image + 'blergh')
    end
  end
end
