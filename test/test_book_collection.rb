$LOAD_PATH.unshift File.expand_path('../..', __FILE__)
require 'book_collection'
require 'minitest/autorun'
require 'minitest/pride'

class TestBookCollection < Minitest::Test

  def test_source_file_name_is_passed
    bookCollection = BookCollection.new("filename")  
    assert_equal("filename", bookCollection.sourceFileName)
  end

  def test_sourceFile_is_a_string
    bookCollection = BookCollection.new("filename")  
    assert_kind_of(String, bookCollection.sourceFile)
  end
  
end
