$LOAD_PATH.unshift File.expand_path('../..', __FILE__)
require 'book_collection'
require 'minitest/autorun'
require 'minitest/pride'

class TestBookCollection < Minitest::Spec

  describe "book collection" do

    it "identifies an author at the top" do
      source_file = ["#blee blue", "froggy foo"]
      book_collection = BookCollection.new(source_file)
      _(book_collection.authors.first).must_equal("blee blue")
    end

    it "identifies two authors, ignoring a non-author line" do
      source_file = ["#birdy boo", "##froggy foo", "#goopy goo"] 
      book_collection = BookCollection.new(source_file)
      _(book_collection.authors).must_equal(["birdy boo", "goopy goo"])
    end
  end
end
