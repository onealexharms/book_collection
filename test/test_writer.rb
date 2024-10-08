$LOAD_PATH.unshift File.expand_path('..', __dir__)
require 'writer'
require 'book_collection'
require 'minitest/autorun'
require 'minitest/pride'
require 'fileutils'

class TestWriter < Minitest::Spec

  before do
    source_file = "test/test_data/mini_index.md"
    @tree = BookCollection.new(source_file).the_tree

    @target_path = "test/test_data/temp/"
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

#    it 'finds images' do
#      @writer.write
#      image = 
#        @target_path + "Ada_Palmer/Terra_Ignota/Too_Like_the_Lightning/1_too_like_the_lightning.jpg"
#      puts image
#      _(File.exist? image).must_equal true
#      _(File.exist? image + "blergh").must_equal false
#end
#    it 'copies images' do
#      @writer.write
#      new_image = 
#        @target_path + "William_Gibson/Sprawl_Trilogy/Neuromancer/Image 08-20-24, 21-23.jpeg"
#      _(File.exist? new_image).must_equal true
    end
  end
