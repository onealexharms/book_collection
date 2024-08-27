$LOAD_PATH.unshift File.expand_path('../..', __FILE__)
require 'book_collection'
require 'minitest/autorun'
require 'minitest/pride'
require 'fileutils'

class TestBookCollection < Minitest::Spec
  DESTINATION_FILE_PATH = "./test/test_data/target/"
  SOURCE_FILE_PATH = "./test/test_data/fake_index.md"

before do
  FileUtils.remove_dir DESTINATION_FILE_PATH if Dir.exist?(DESTINATION_FILE_PATH)
  @book_collection = BookCollection.new SOURCE_FILE_PATH, DESTINATION_FILE_PATH 
  puts "-----------------------------------"
end

  describe "book collection" do
      
    it "test data is vetted" do
      _(@book_collection.author_names.size)
        .must_equal 97
    end

    it "knows when the first thing is an author" do
      _(@book_collection.author_names.first)
        .must_equal "Ada Palmer"
    end

    it "knows which things are authors" do
      _(@book_collection.author_names[0..2])
        .must_equal ["Ada Palmer",
                     "Adrian Tchaikovsky",
                     "Alex White"]
    end

    it "knows what a book title is" do
      _(@book_collection.titles.first)
        .must_equal "Too Like the Lightning"
    end

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

    it "knows author directory name" do
      author = @book_collection.author_names.first
      _(@book_collection.author_names_to_directories.first).must_equal("ada-palmer")
    end

    it "knows more author directory names" do
      _(@book_collection.author_names_to_directories[0..2]).must_equal ["ada-palmer","adrian-tchaikovsky", "alex-white"]
    end

    it "has a file for the first author" do
      _(File.exist?("#{DESTINATION_FILE_PATH}ada-palmer")).must_equal(true)
    end
  end
end

