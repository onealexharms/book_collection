$LOAD_PATH.unshift File.expand_path('../..', __FILE__)
require 'book_collection'
require 'minitest/autorun'
require 'minitest/pride'

class TestBookCollection < Minitest::Test
  def test_source_file_name_is_index_md
    bookCollection = BookCollection.new
    assert_equal("index.md", bookCollection.sourceFileName)
  end

  def test_source_file_exists
    bookCollection = BookCollection.new
    assert File.exist?(bookCollection.sourceFileName)
  end

  def test_source_file_has_expected_stuff
    bookCollection = BookCollection.new
    contents = IO.read(bookCollection.sourceFileName)    
    assert contents.include?(".jpg")
    assert contents.include?(".webp")
    assert contents.include?("# ")
  end    
  
end
