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

=begin

=====================================================
 Need to a) figure out how to make that test work ^^^
 and b) add text to the title files
 and maybe c) put images in directory with title.md,
 but maybe not.
=====================================================


    it "knows what an image is" do
      _(@book_collection.image_filenames.first).must_equal "1_too_like_the_lightning.jpg"
    end

    it "knows what images are" do
      _(@book_collection.image_filenames[0..3])
        .must_equal ["1_too_like_the_lightning.jpg",
                     "2_seven_surrenders.jpg",
                     "3_the_will_to_battle.jpeg",
                     "4_perhaps_the_stars.jpeg"]
    end

    it "has directories for authors" do
      directory = Dir.new DESTINATION_FILE_PATH
      author_directories = directory.children
      _(author_directories).must_include "ada_palmer"
      _(author_directories).must_include "becky_chambers"
      _(author_directories).must_include "ursula_k_leguin"
    end

    describe "directories for world level" do
      it "has them when the world level is the series name" do
        author_directory = Dir.new "#{DESTINATION_FILE_PATH}ada_palmer" 
        _(author_directory.children).must_include "terra_ignota"
      end

      it "has them when the world has series below it" do
        author_directory = Dir.new "#{DESTINATION_FILE_PATH}victoria_goddard" 
        _(author_directory.children).must_include "the_nine_worlds"
      end

      it "has them when the world has punctuation" do
        directory_with_parens = Dir.new "#{DESTINATION_FILE_PATH}william_gibson"
        _(directory_with_parens.children).must_include 'burning_chrome_stories'
        directory_with_apostrophe = Dir.new "#{DESTINATION_FILE_PATH}john_scalzi"
        _(directory_with_apostrophe.children).must_include "old_mans_war"
        newline_manually_fixed = Dir.new "#{DESTINATION_FILE_PATH}patrick_rothfuss"
        _(newline_manually_fixed.children).must_include "the_name_of_the_wind"
      end
    end 

  describe "series level directories" do
      it "knows the jackpot trilogy is its own world" do
        directory = Dir.new "#{DESTINATION_FILE_PATH}william_gibson/jackpot_trilogy"
        _(directory.children).must_be_empty
      end
      it "has a westlands series under the deverry world" do
        deverry_world = 
          Dir.new "#{DESTINATION_FILE_PATH}katherine_kerr/deverry_world"
          _(deverry_world.children).must_include "westlands"
      end

      it "has A Time of Omens in the Westlands folder" do
        westlands = 
          Dir.new "#{DESTINATION_FILE_PATH}katherine_kerr/deverry_world/westlands/"
          _(westlands.children).must_include "a-time-of-ooomens"
      end
    end
=end
  end
end
