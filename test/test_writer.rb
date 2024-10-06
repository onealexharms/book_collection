$LOAD_PATH.unshift File.expand_path('..', __dir__)
require 'writer'
require 'minitest/autorun'
require 'minitest/pride'
require 'fileutils'

class TestWriter < Minitest::Spec
  before do
    @tree = {"Herman_Melville/Moby_Dick/" =>
            ["There's this whale, see, and...",
             "Image%20of%20,a%20whale.xyz",
             "cover.xyz"]}
    @target_path = "test/test_data/temp/"
    FileUtils.rm_rf @target_path
    Dir.mkdir @target_path
    @writer = Writer.new(@tree, @target_path)
  end

  describe Writer do
    it 'has a tree' do
      _(@tree.keys.first).must_equal "Herman_Melville/Moby_Dick/"
    end

    it 'writes directories' do
      @writer.write_directories
      _(Dir.exist? "test/test_data/temp/Herman_Melville/Moby_Dick/").must_equal true
    end

    it 'writes descriptions' do
      @writer.write
      description = @target_path + "Herman_Melville/Moby_Dick/Moby_Dick.md"
      _(File.exist? description).must_equal true
      _(File.readlines(description).first).must_include "There's this whale, see, and..."
    end

  end
end

