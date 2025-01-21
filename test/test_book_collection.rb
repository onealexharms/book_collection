$LOAD_PATH.unshift File.expand_path('..', __dir__)
require 'book_collection'
require 'minitest/autorun'
require 'minitest/pride'
require 'fileutils'

class TestBookCollection < Minitest::Spec
  before do
    source_file = 'test/test_data/mini_index.md'
    @image_source = (just_path_from source_file) + '/images/'
    filename = File.basename(source_file)
    book_collection = BookCollection.new source_file
    @tree = book_collection.the_tree
  end

  def just_path_from source_file
    parts = source_file.split('/')
    parts.reject! {|part| part == File.basename(source_file)}
    parts.join('/')
  end

  describe "book collection" do

    it 'has a title path for All Tomorrow\'s Parties without apostrophe' do 
      _(@tree.keys).must_include 'William_Gibson/Bridge_Trilogy/All_Tomorrows_Parties/'
    end

    it 'has an image path for Neuromancer with escaped spaces instead of %20' do
      title = 'William_Gibson/Sprawl_Trilogy/Neuromancer/'
      image_path = @image_source + "Image 2008-20-24, 21-23.jpeg"
      _(@tree[title][1]).must_equal(image_path)
    end

    it 'has images' do
      title = 'Ada_Palmer/Terra_Ignota/Too_Like_the_Lightning/'
      image_path = @image_source + '1_too_like_the_lightning.jpg'
      _(@tree[title][1]).must_equal(image_path)
    end

    it 'has descriptions' do
      title = 'William_Gibson/Jackpot_Trilogy/The_Peripheral/'
      _(@tree[title][0]).must_include 'Flynne Fisher lives'
    end
  end
end
