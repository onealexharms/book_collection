#!/usr/bin/env ruby

require './book_collection'
require './writer'
source_path, target = ARGV

book_collection = BookCollection.new source_file
tree = book_collection.the_tree

writer = Writer.new(source_file, tree, target)
writer.write
