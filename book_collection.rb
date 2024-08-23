class BookCollection
  attr_reader :sourceFileName

  def initialize(filename)
    @sourceFileName = filename
  end
end
