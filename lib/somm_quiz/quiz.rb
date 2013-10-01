module SommQuiz
  class Quiz
    def initialize(n = 20)
      @topics = Topic::Manager.random n
    end

    def topics
      @topics
    end
  end
end
