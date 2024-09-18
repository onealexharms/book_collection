$LOAD_PATH.unshift File.expand_path('..', __dir__)
require 'book_collection'
require 'minitest/autorun'
require 'minitest/pride'
require 'fileutils'

class TestBookCollection < Minitest::Spec
  before do
    data = File.readlines('test/test_data/normalized_index.md')
    @book_collection = BookCollection.new data
  end

  describe 'book collection' do
    it "has an array of title directories as keys" do
      _(@book_collection.the_tree.keys).must_be_kind_of Array
    end

    it 'has a title path for All Tomorrow\'s Parties without apostrophe' do
      _(@book_collection.the_tree.keys).must_include 'William_Gibson/Bridge_Trilogy/All_Tomorrows_Parties/' 
    end
    
    it 'has a world for Too Like the Lightning' do
      _(@book_collection.the_tree.keys).must_include 'Ada_Palmer/Terra_Ignota/Too_Like_the_Lightning/'
    end
    
    it 'has a world and series' do
      _(@book_collection.the_tree.keys).must_include 'Robin_Hobb/Realm_of_the_Elderlings/Farseer_Trilogy/Assassins_Apprentice/'
    end

    it 'has images' do
      title = 'Ada_Palmer/Terra_Ignota/Too_Like_the_Lightning'
      _(@book_collection.the_tree['Ada_Palmer/Terra_Ignota/Too_Like_the_Lightning/'][1]).must_equal '1_too_like_the_lightning.jpg'
    end
  end
end
