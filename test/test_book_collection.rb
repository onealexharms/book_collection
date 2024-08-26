$LOAD_PATH.unshift File.expand_path('../..', __FILE__)
require 'book_collection'
require 'minitest/autorun'
require 'minitest/pride'

class TestBookCollection < Minitest::Spec

  describe "book collection" do
    SOURCE_FILE_PATH = "test/test_data/fake_index.md"
    DESTINATION_FILE_PATH = "test/test_data/"
    source_file_lines = File.readlines SOURCE_FILE_PATH
    book_collection = BookCollection.new source_file_lines

      it "authors are all there" do
        _(book_collection.authors.size)
          .must_equal 97
      end

      it "knows when the first thing is an author" do
        _(book_collection.authors.first)
          .must_equal "Ada Palmer"
      end

      it "knows which things are authors" do
        _(book_collection.authors[0..2])
          .must_equal ["Ada Palmer",
                       "Adrian Tchaikovsky",
                       "Alex White"]
      end

      it "knows what a book title is" do
        _(book_collection.titles.first)
          .must_equal "Too Like the Lightning"
      end

      it "knows the author of a book" do

      end

      it "knows what an image is" do
        _(book_collection.images.first).must_equal "1_too_like_the_lightning.jpg"
      end

      it "knows what images are" do
        _(book_collection.images[0..3])
          .must_equal ["1_too_like_the_lightning.jpg",
                       "2_seven_surrenders.jpg",
                       "3_the_will_to_battle.jpeg",
                       "4_perhaps_the_stars.jpeg"]
      end

      it "knows author filename" do
        author = book_collection.authors.first
        _(book_collection.author_filenames.first).must_equal("ada-palmer")
      end

      it "knows more author filenames" do
        _(book_collection.author_filenames[0..2]).must_equal ["ada-palmer","adrian-tchaikovsky", "alex-white"]
      end
  end
end
