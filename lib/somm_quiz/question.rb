module SommQuiz
  class NoSubjectError < Exception
  end

  class NoAnswersError < Exception
  end

  class MalformedAnswerError < Exception
  end

  class MissingCorrectAnswerError < Exception
  end

  class MissingCorrectMessageError < Exception
  end

  class MissingIncorrectMessageError < Exception
  end

  class Question
    attr_reader :subject

    def initialize(options = {})
      @subject = options.delete(:subject) || raise(NoSubjectError)
      @subject = @subject.to_s

      @answers = options.delete(:answers) || raise(NoAnswersError)
      raise(NoAnswersError) unless @answers.respond_to?(:to_ary)
      raise(NoAnswersError) unless @answers.size > 1

      @answers.each do |answer|
        raise MalformedAnswerError unless (answer.has_key?(:option) && answer.has_key?(:correct))
      end

      raise MissingCorrectAnswerError unless @answers.map{|a| a[:correct]}.select{|a| a}.size > 0

      @correct = options.delete(:correct) || raise(MissingCorrectMessageError)
      @correct = @correct.to_s

      @incorrect = options.delete(:incorrect) || raise(MissingIncorrectMessageError)
      @incorrect = @incorrect.to_s
    end
  end
end
