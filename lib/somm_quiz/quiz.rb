module SommQuiz
  class Quiz
    def initialize(n = 20)
      @topics = Topic::Manager.random n
      @questions = []
      fill_questions
    end

    def topics
      @topics
    end

    def questions
      @questions
    end

    def fill_questions
      @topics.each do |topic|
        @questions << topic.ask
      end
    end
  end
end
