class BookCollection
  attr_reader :sourceFile
  attr_reader :header

  def initialize(sourceFile)
    @sourceFile = sourceFile
    @header = top_level_header_from(sourceFile)
  end

  def top_level_header_from(sourceFile)
    headers_found = sourceFile.match(/[^\#]+\#([^\#].*)/)
    headers_found.nil? ? "" : headers_found.captures.first 
  end
end
