module SommQuiz
  module RedisPersistence
    def self.included(base)
      class << base
        deprecate :all, :first
      end
    end
  end
end
