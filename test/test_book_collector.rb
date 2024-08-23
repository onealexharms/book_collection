$LOAD_PATH.unshift File.expand_path('../..', __FILE__)
require 'book_collector'
require 'minitest/autorun'
require 'minitest/pride'

class TestBookCollector < Minitest::Test
  def test_file_name_is_index_md
    bookCollector = BookCollector.new
    assert_equal("index.md", bookCollector.bigFile)
  end

  def test_file_exists
    bookCollector = BookCollector.new
    assert File.exist?(bookCollector.bigFile)
  end

  def test_file_contains_expected_stuff
    bookCollector = BookCollector.new
    contents = IO.read(bookCollector.bigFile)    
    assert contents.include?(".jpg")
    assert contents.include?(".webp")
    assert contents.include?("# ")
  end    

  
end
