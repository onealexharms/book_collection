$LOAD_PATH.unshift File.expand_path('..', __dir__)
require 'book_collection'
require 'minitest/autorun'
require 'minitest/pride'
require 'fileutils'

class TestBookCollection < Minitest::Spec
  before do
    source_file = 'test/test_data/mini_index.md'
    book_collection = BookCollection.new source_file
    @tree = book_collection.the_tree
  end

  describe "book collection" do

    it 'has a title path for All Tomorrow\'s Parties without apostrophe' do 
      _(@tree.keys).must_include 'William_Gibson/Bridge_Trilogy/All_Tomorrows_Parties/'
    end

    it 'has images' do
      title = 'Ada_Palmer/Terra_Ignota/Too_Like_the_Lightning/'
      _(@tree[title][1]).must_equal 'data/images/1_too_like_the_lightning.jpg'
    end

    it 'has descriptions' do
      title = 'William_Gibson/Jackpot_Trilogy/The_Peripheral/'
      _(@tree[title][0]).must_include 'Flynne Fisher lives'
    end
  end
end
