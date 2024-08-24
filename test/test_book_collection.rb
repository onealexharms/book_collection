$LOAD_PATH.unshift File.expand_path('../..', __FILE__)
require 'book_collection'
require 'minitest/autorun'
require 'minitest/pride'

class TestBookCollection < Minitest::Spec

  describe "a book collection" do

    it "identifies a top level header when it's top" do
      source_file = ["#blee blue", "froggy foo"]
      book_collection = BookCollection.new(source_file)
      _(book_collection.headers.first).must_equal("blee blue")
    end

    it "identifies two top-level headers" do
      source_file = ["#birdy boo", "##froggy foo", "#goopy goo"] 
      book_collection = BookCollection.new(source_file)
      _(book_collection.headers).must_equal(["birdy boo", "goopy goo"])
    end

    it "ignores lower headers" do
      source_file = ["##blee blue"]
      book_collection = BookCollection.new(source_file)
      _(book_collection.headers).must_equal([])
    end
  end
end

