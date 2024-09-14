$LOAD_PATH.unshift File.expand_path('..', __dir__)
require 'book_collection'
require 'minitest/autorun'
require 'minitest/pride'
require 'fileutils'

class TestBookCollection < Minitest::Spec
  DESTINATION_FILE_PATH = './test/test_data/target/'
  SOURCE_FILE_PATH = './test/test_data/fake_index.md'

  before do
    FileUtils.remove_dir(DESTINATION_FILE_PATH) if Dir.exist?(DESTINATION_FILE_PATH)
    @book_collection = BookCollection.new SOURCE_FILE_PATH, DESTINATION_FILE_PATH
  end

  describe 'book collection' do
    
    it 'has directories for authors' do
      _(@book_collection.the_tree.to_s)
        .must_include 'Ada_Palmer/'
      _(@book_collection.the_tree.to_s)
        .must_include 'Becky_Chambers/'
      _(@book_collection.the_tree.to_s)
        .must_include 'Ursula_K_LeGuin/'
    end
  end
end

=begin
    it 'has Too Like the Lightning' do
      _(@book_collection.the_tree).must_include('Ada_Palmer/Terra_Ignota/Too_Like_the_Lightning/Too_Like_the_Lightning.md')
    end
    it 'has the right pic for Too Like the Lightning' do
      path = 'Ada_Palmer/Terra_Ignota/Too_Like_the_Lightning/1_too_like_the_lightning.jpg'
      _(@book_collection.the_tree)
        .must_include(path);
    end
    it 'has the right pic for the last one' do
      image = 
        'William_Gibson/Bridge_Trilogy/All_Tomorrows_Parties/Image%208-20-24,%2021-31-2.jpeg'
      _(@book_collection.the_tree)
        .must_include('William_Gibson/Bridge_Trilogy/All_Tomorrows_Parties/Image%208-20-24,%2021-31-2.jpeg')
    end
    it 'has A Time of Omens in the Westlands folder' do
      _(@book_collection.the_tree)
        .must_include 'Katherine_Kerr/Deverry_World/Westlands/A_Time_of_Omens/A_Time_of_Omens.md'
    end
    it 'does not have authors as sub-directories' do
      _(@book_collection.the_tree.to_s)
        .wont_include '/Ada_Palmer/'
      _(@book_collection.the_tree.to_s)
        .wont_include '/Becky_Chambers/'
      _(@book_collection.the_tree.to_s)
        .wont_include '/Ursula_K_Leguin/'
    end

    it 'when the world level is the series name' do
      _(@book_collection.the_tree.to_s)
        .must_include 'Ada_Palmer/Terra_Ignota/'
    end

    it 'when the world has series below it' do
      _(@book_collection.the_tree.to_s)
        .must_include 'Victoria_Goddard/The_Nine_Worlds/'
    end

    it 'when the world has punctuation' do
      _(@book_collection.the_tree.to_s)
        .must_include 'William_Gibson/Burning_Chrome_stories/'
      _(@book_collection.the_tree.to_s)
        .must_include 'John_Scalzi/Old_Mans_War/'
      _(@book_collection.the_tree.to_s)
        .must_include 'Patrick_Rothfuss/The_Name_of_the_Wind/'
    end

    it 'knows the jackpot trilogy is its own world' do
      _(@book_collection.the_tree.to_s)
        .must_include 'William_Gibson/Jackpot_Trilogy/'
    end

    it 'has a Westlands series under the deverry world' do
      _(@book_collection.the_tree.to_s)
        .must_include 'Katherine_Kerr/Deverry_World/Westlands/'
    end

    it 'has a directory for A Time of Omens' do
     _(@book_collection.the_tree)
      .must_include 'Katherine_Kerr/Deverry_World/Westlands/A_Time_of_Omens/'
     end
     Galaxy and the Ground Within has no image in the test file
=end
