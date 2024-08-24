$LOAD_PATH.unshift File.expand_path('../..', __FILE__)
require 'book_collection'
require 'minitest/autorun'
require 'minitest/pride'

class TestBookCollection < Minitest::Spec

  describe "a book collection" do

    it "identifies a top level header" do
      sourceFile = ["#blee blue"]
      bookCollection = BookCollection.new(sourceFile)
      _(bookCollection.headers.first).must_equal("blee blue")
    end

    it "doesn't find lower headers" do
      sourceFile = ["##blee blue"]
      bookCollection = BookCollection.new(sourceFile)
      _(bookCollection.headers).must_equal([nil])
    end
  end
end

