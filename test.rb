#!/usr/bin/env ruby

require './book_collection'
require './writer'
source_file = "test/test_data/mini_index.md"
target_path = "data/results/"
if Dir.exist? target_path
  FileUtils.rm_rf target_path
end
gets
book_collection = BookCollection.new source_file
tree = book_collection.the_tree

writer = Writer.new(tree, target_path)
writer.write
