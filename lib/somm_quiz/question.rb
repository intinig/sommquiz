require 'json'

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

      @answers = options.delete(:answers) || raise(NoAnswersError, options.inspect)
      raise(NoAnswersError, options.inspect) unless @answers.respond_to?(:to_ary)
      raise(NoAnswersError, options.inspect) unless @answers.size > 1

      @answers.each do |answer|
        raise MalformedAnswerError unless (answer.has_key?(:option) && answer.has_key?(:correct))
      end

      raise MissingCorrectAnswerError unless @answers.map{|a| a[:correct]}.select{|a| a}.size > 0

      @correct = options.delete(:correct) || raise(MissingCorrectMessageError)
      @correct = @correct.to_s

      @incorrect = options.delete(:incorrect) || raise(MissingIncorrectMessageError)
      @incorrect = @incorrect.to_s

      @select_any = options.delete(:select_any)
    end

    def to_json(options = {})
      {
        "q" => @subject,
        "a" => @answers,
        "correct" => @correct,
        "incorrect" => @incorrect,
        "select_any" => @select_any
      }.to_json
    end
  end
end
