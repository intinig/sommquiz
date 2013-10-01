module SommQuiz
  module Topic
    class Base
      attr_reader :name

      def ==(other)
        self.class == other.class && self.name == other.name
      end

      def eql?(other)
       self == other
      end
    end
  end
end
