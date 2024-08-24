class BookCollection
  attr_reader :source_file

  def initialize(source_file)
    @source_file = source_file
  end

  def headers
    headers = []
    @source_file.each do |line| 
      finds = line.match(/^[\#](?<header>[^#].*)/)
      puts finds.inspect

      if finds && finds[:header]
         headers << finds[:header]
      end
    end
    headers
  end
end
