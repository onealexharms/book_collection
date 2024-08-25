class BookCollection
  attr_reader :source_file

  def initialize(source_file)
    @source_file = source_file
  end

  def authors
    authors = []
    @source_file.each do |line| 
      found_stuff = line.match(/^[\#](?<header>[^#].*)/)
      if found_stuff && found_stuff[:header]
         authors << found_stuff[:header]
      end
    end
    authors
  end
end
