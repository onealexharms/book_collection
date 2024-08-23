$LOAD_PATH.unshift File.expand_path('../..', __FILE__)
require 'book_collection'
require 'minitest/autorun'
require 'minitest/pride'

class TestBookCollection < Minitest::Test
  def test_source_file_name_is_index_md
    bookCollection = BookCollection.new("filename")
    assert_equal("filename", bookCollection.sourceFileName)
  end

  def sourceFile_is_a_string
    assert_kind_of(String, sourceFile)
  end
end
