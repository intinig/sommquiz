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

      def ask
        Question.new(
          :subject => "x",
          :answers  => [
            {
              :option => "Enzo",
              :correct => "True"
            },
            { :option => "Ronald",
              :correct => "McDonald"
            }
          ],
          :correct => "Ciao",
          :incorrect => "Mamma",
          )
      end
    end
  end
end
