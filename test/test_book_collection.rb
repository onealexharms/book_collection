$LOAD_PATH.unshift File.expand_path('..', __dir__)
require 'book_collection'
require 'minitest/autorun'
require 'minitest/pride'
require 'fileutils'

class TestBookCollection < Minitest::Spec
  before do
    fake_data = File.readlines('test/test_data/test_index.md')
    @book_collection = BookCollection.new fake_data
  end

  describe 'book collection' do
    it "has an array of title directories as keys" do
      _(@book_collection.the_tree.keys).must_be_kind_of Array
    end

    it 'has a title path for Too Like the Lightning' do
      title = '[Too Like the Lightning]'
      _(@book_collection.the_tree.keys).must_include 'Too_Like_the_Lightning/'
    end
  end
end
