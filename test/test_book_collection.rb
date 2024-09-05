$LOAD_PATH.unshift File.expand_path('../..', __FILE__)
require 'book_collection'
require 'minitest/autorun'
require 'minitest/pride'
require 'fileutils'

class TestBookCollection < Minitest::Spec
  DESTINATION_FILE_PATH = "./test/test_data/target/"
  SOURCE_FILE_PATH = "./test/test_data/fake_index.md"

  before do
    FileUtils.remove_dir(DESTINATION_FILE_PATH)if Dir.exist?(DESTINATION_FILE_PATH)
    @book_collection = BookCollection.new SOURCE_FILE_PATH, DESTINATION_FILE_PATH 
  end

  describe "book collection" do
    it "has Too Like the Lightning" do
      _(@book_collection.the_tree).must_include("ada_palmer/terra_ignota/too_like_the_lightning/too_like_the_lightning.md") 
    end

    it "has the right pic for Too Like the Lightning" do
      _(@book_collection.the_tree).must_include("ada_palmer/terra_ignota/too_like_the_lightning/1_too_like_the_lightning.jpg") 
    end
    
    it 'has the right pic for the last one' do
      _(@book_collection.the_tree).must_include('william_gibson/bridge_trilogy/all_tomorrows_parties/image%208-20-24%2021-31-2.jpeg') 
    end

    it "has directories for authors" do
      _(@book_collection.the_tree)
        .must_include "ada_palmer/"
      _(@book_collection.the_tree)
        .must_include "becky_chambers/"
      _(@book_collection.the_tree)
        .must_include "ursula_k_leguin/"
    end

    it 'does not have authors as sub-directories' do
      _(@book_collection.the_tree)
        .wont_include "/ada_palmer/"
      _(@book_collection.the_tree)
        .wont_include "/becky_chambers/"
      _(@book_collection.the_tree)
        .wont_include "/ursula_k_leguin/"
    end

    describe "directories for world level" do
      it "has them when the world level is the series name" do
        _(@book_collection.the_tree)
          .must_include 'ada_palmer/terra_ignota/'
      end

      it "has them when the world has series below it" do
        _(@book_collection.the_tree)
          .must_include 'victoria_goddard/the_nine_worlds/'
      end
      it "has them when the world has punctuation" do
        _(@book_collection.the_tree)
          .must_include 'william_gibson/burning_chrome_stories/'
        _(@book_collection.the_tree)
          .must_include 'john_scalzi/old_mans_war/'
        _(@book_collection.the_tree)
          .must_include 'patrick_rothfuss/the_name_of_the_wind/'
      end
    end 

    describe "series level directories" 

    it "knows the jackpot trilogy is its own world" do
      _(@book_collection.the_tree)
        .must_include 'william_gibson/jackpot_trilogy/'
    end

    it "has a westlands series under the deverry world" do
      _(@book_collection.the_tree)
        .must_include 'katherine kerr/deverry_world/westlands/'
    end

    it "has A Time of Omens in the Westlands folder" do
      westlands = 
        Dir.new "#{DESTINATION_FILE_PATH}katherine_kerr/deverry_world/westlands/"
      _(westlands.children).must_include "a-time-of-ooomens"
    end
  end
end
