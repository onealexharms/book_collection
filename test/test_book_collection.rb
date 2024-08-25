$LOAD_PATH.unshift File.expand_path('../..', __FILE__)
require 'book_collection'
require 'minitest/autorun'
require 'minitest/pride'

class TestBookCollection < Minitest::Spec
  @@source_file_path = "test/test_data/fake_index.md"
  @@source_file = File.readlines @@source_file_path

  describe "book collection" do

    describe "the test data file" do

      it "can be found" do
        source_file_path = "test/test_data/fake_index.md"
        _(File.exist?(@@source_file_path)).must_equal(true)
      end

      it "contains a hundred or so authors" do
        book_collection = BookCollection.new @@source_file
        _(book_collection.authors.size)
          .must_be_close_to 150, 100
      end
    end

    it "identifies an author at the top" do
      source_file = ["#blee blue", "froggy foo"]
      book_collection = BookCollection.new(source_file)
      _(book_collection.authors.first)
        .must_equal("blee blue")
    end

    it "identifies two authors, ignoring a non-author line" do
      source_file = ["#birdy boo", "##froggy foo", "#goopy goo"]
      book_collection = BookCollection.new(source_file)
      _(book_collection.authors)
        .must_equal(["birdy boo", "goopy goo"])
    end
  end
  end
