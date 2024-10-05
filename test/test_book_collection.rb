$LOAD_PATH.unshift File.expand_path('..', __dir__)
require 'book_collection'
require 'minitest/autorun'
require 'minitest/pride'
require 'fileutils'

class TestBookCollection < Minitest::Spec
  before do
    data = 'test/test_data/normalized_index.md'
    book_collection = BookCollection.new data
    @tree = book_collection.the_tree
  end

  describe "book collection" do
    it 'includes new image name, cover.{extension}' do      
      mini_data = 'test/test_data/mini_index.md'
      mini_collection = BookCollection.new mini_data
      tree = mini_collection.the_tree
      _(tree["William_Gibson/Sprawl_Trilogy/Neuromancer/"]).must_equal ["Case was the sharpest.", "Image%2008-20-24,%2021-23.jpeg", "cover.jpeg"]
  end

    it 'has a title path for All Tomorrow\'s Parties without apostrophe' do 
      _(@tree.keys).must_include 'William_Gibson/Bridge_Trilogy/All_Tomorrows_Parties/'
    end

    it 'has a world and series' do
      _(@tree.keys).must_include 'Robin_Hobb/Realm_of_the_Elderlings/Farseer_Trilogy/Assassins_Apprentice/'
    end

    it 'has images' do
      title = 'Ada_Palmer/Terra_Ignota/Too_Like_the_Lightning/'
      _(@tree[title][1]).must_equal '1_too_like_the_lightning.jpg'
    end

    it 'has descriptions' do
      title = 'William_Gibson/Jackpot_Trilogy/The_Peripheral/'
      _(@tree[title][0]).must_include 'Flynne Fisher lives down a country road,'
    end
  end
end
