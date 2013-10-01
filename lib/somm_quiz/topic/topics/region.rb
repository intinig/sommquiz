require __dir__ + "/../../../../lib/models"

module SommQuiz
  module Topic
    class Region < Base
      def self.availability
        Object::Region.count
      end

      def initialize(options = {})
        exclude = options[:exclude]
        @data = Object::Region.all(:name.not => exclude).sample
        @name = @data.name
      end
    end
  end
end
