$LOAD_PATH.unshift File.expand_path('../..', __FILE__)
require 'book_collection'
require 'minitest/autorun'
require 'minitest/pride'

class TestBookCollection < Minitest::Spec

  describe "a book collection" do

      it "finds a top level header" do
        sourceFile = "blah bloo #blee blue"
        bookCollection = BookCollection.new(sourceFile)
        _(bookCollection.header).must_equal("blee blue")
      end

      it "doesn't find lower headers" do
        sourceFile = "blah bloo ##blee blue"
        bookCollection = BookCollection.new(sourceFile)
        _(bookCollection.header).must_equal("")
      end
  end
end
