$LOAD_PATH.unshift File.expand_path('../..', __FILE__)
require 'book_collection'
require 'minitest/autorun'
require 'minitest/pride'

class TestBookCollection < Minitest::Spec
  @@SOURCE_FILE_PATH = "test/test_data/fake_index.md"
  @@DESTINATION_FILE_PATH = "test/test_data/"
  @@source_file_lines = File.readlines @@SOURCE_FILE_PATH

  describe "book collection" do

    describe "test data file" do

      it "can be found" do
        SOURCE_FILE_PATH = "test/test_data/fake_index.md"
        _(File.exist?(@@SOURCE_FILE_PATH)).must_equal true
      end

      it "contains a hundred or so authors" do
        book_collection = BookCollection.new @@source_file_lines
        _(book_collection.authors.size)
          .must_be_close_to 150, 100
      end
    end

    it "knows when the first thing is an author" do
      source_file = ["#blee blue", "froggy foo"]
      book_collection = BookCollection.new source_file
      _(book_collection.authors.first)
        .must_equal "blee blue"
    end

    it "knows which things are authors" do
      fake_source_file = ["#birdy boo",
                          "##froggy foo",
                          "#goopy goo",
                          "betty boo",
                          "#looptie doo"]
      book_collection = BookCollection.new fake_source_file
      _(book_collection.authors)
        .must_equal ["birdy boo",
                     "goopy goo",
                     "looptie doo"]
    end

    it "knows what a book title is" do
      fake_source_file = ["#birdy boo",
                          "##froggy foo",
                          "[I am a title]",
                          "#goopy goo",
                          "betty boo",
                          "#looptie doo"]
      book_collection = BookCollection.new fake_source_file
      _(book_collection.titles.first)
        .must_equal "I am a title"
    end

    it "knows what an image is" do
      fake_source_file = ["#birdy boo",
                          "##froggy foo",
                          "[I am a title]",
                          "#goopy goo",
                          "|  |![](an-image.jpg)  |  |",
                          "betty boo",
                          "#looptie doo"]
      book_collection = BookCollection.new fake_source_file
      _(book_collection.images.first)
        .must_equal "an-image.jpg"
    end

    it "knows author filename" do
      fake_source_file = ["#Birdy Boo",
                          "##froggy foo",
                          "[I am a title]",
                          "#goopy goo",
                          "|  |![](an-image.jpg)  |  |",
                          "betty boo",
                          "#looptie doo"]
      book_collection = BookCollection.new fake_source_file
      author = book_collection.authors.first
      _(book_collection.author_filenames.first).must_equal("birdy-boo")
    end

    it "knows more author filenames" do
      fake_source_file = ["#Birdy Boo",
                          "##froggy foo",
                          "[I am a title]",
                          "#goopy goo",
                          "|  |![](an-image.jpg)  |  |",
                          "betty boo",
                          "#looptie doo"]
      book_collection = BookCollection.new fake_source_file
      _(book_collection.author_filenames).must_equal ["birdy-boo","goopy-goo", "looptie-doo"]
    end
  end
end

