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

=begin
[{:author_name => "Ada Palmer", 
  :books => 
    [{:title => "Seven Surrenders", :image => seven_surrenders.jpg, :commentary => commentary.md} 
    {:title => zzz, :image => kljadfg, commentary => sokmehting.md}, 
    {:title => "Too Like the Lightning", :image => image95.jpg, :commentary => commentary.md],
{:author_name => "Ursula LeGuin", 
  :books => 
  [{:title => "The Left Hand of Darkness", :image => image42.png, :commentary => commentary.md}, 
  {:title => "The Word for World is Forest", :image => image523.webp, :commentary => commentary.md},
  {:title => "A Wizard of Earthsea", :image => y.img, :commentary = z.md}]]

=end
