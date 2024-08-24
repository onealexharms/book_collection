class BookCollection
  attr_reader :sourceFile
  attr_reader :headers

  def initialize(sourceFile)
    @sourceFile = sourceFile
    @headers = headers_in(sourceFile) 
  end

  def headers_in(sourceFile)
    @headers = []
    line = sourceFile.first
    header = line.match(/^[\#]([^\#].*)/).to_a[1]
    @headers << header
  end
end
