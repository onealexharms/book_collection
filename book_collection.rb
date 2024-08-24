class BookCollection
  attr_reader :sourceFile

  def initialize(sourceFile)
    @sourceFile = sourceFile
  end

  def headers
    headers = []
    @sourceFile.each do |line| 
      finds = line.match(/^[\#](?<header>[^#].*)/)
      puts finds.inspect

      if finds && finds[:header]
         headers << finds[:header]
      end
    end
    headers
  end
end
