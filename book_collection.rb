class BookCollection
  attr_reader :sourceFileName
  attr_reader :sourceFile

  def initialize(filename)
    @sourceFileName = filename
    @sourceFile = ""
  end
end
