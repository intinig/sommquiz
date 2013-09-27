require 'recursive_open_struct'

class Tasting < RecursiveOpenStruct
  def initialize
    @data = YAML.load_file(File.dirname(__FILE__) + "/../../db/tasting.yml")
    super @data["tasting"]
  end
end
