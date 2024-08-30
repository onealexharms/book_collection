$LOAD_PATH.unshift File.expand_path('../..', __FILE__)
require 'book_collection'
require 'minitest/autorun'
require 'minitest/pride'
require 'fileutils'

class TestBookCollection < Minitest::Spec
  DESTINATION_FILE_PATH = "./test/test_data/target/"
  SOURCE_FILE_PATH = "./test/test_data/fake_index.md"
  #fake_index.md is actually the good one

before do
  FileUtils.remove_dir(DESTINATION_FILE_PATH)if Dir.exist?(DESTINATION_FILE_PATH)
  @book_collection = BookCollection.new SOURCE_FILE_PATH, DESTINATION_FILE_PATH 
end

  describe "book collection" do
      
    it "test data is vetted" do
      _(@book_collection.author_names.size)
        .must_equal 97
    end

    it "knows what a book title is" do
      titles = @book_collection.titles 
      _(titles).must_include("Too Like the Lightning")
      _(titles).must_include("Neuromancer")
      _(titles).must_include("A Closed and Common Orbit")
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

    it "has files for authors" do
      _(File.exist?("#{DESTINATION_FILE_PATH}ada_palmer")).must_equal(true)
      _(File.exist?("#{DESTINATION_FILE_PATH}becky_chambers")).must_equal(true)
      _(File.exist?("#{DESTINATION_FILE_PATH}ursula_k_leguin")).must_equal(true)
    end

    it "has a directories for world level" do
      _(File.exist?("#{DESTINATION_FILE_PATH}ada_palmer/terra_ignota")).must_equal(true)
      _(File.exist?("#{DESTINATION_FILE_PATH}victoria_goddard/the_nine_worlds")).must_equal(true)
      _(File.exist?("#{DESTINATION_FILE_PATH}/william_gibson/burning_chrome_stories")).must_equal(true)
      
    end
  end
end
