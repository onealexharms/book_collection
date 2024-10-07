#!/usr/bin/env ruby

require './book_collection'
require './writer'
source_path, target_path = ARGV

book_collection = BookCollection.new source_path
tree = book_collection.the_tree

writer = Writer.new(tree, target_path)
writer.write
