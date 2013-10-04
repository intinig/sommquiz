require __dir__ + "/../spec_helper"
require __dir__ + "/../../lib/somm_quiz"

describe SommQuiz::Question do
  let(:dummy_question) do
    {
      :subject => "Come ti chiami?",
      :answers => [
        {
            :option => "Giovanni", :correct => true
        },
        {
          :option => "Enzo", :correct => false
        }
      ],
      :correct => "Bravo, ti chiami proprio Giovanni",
      :incorrect => "Eh no, non ti chiami Giovanni"
    }
  end

  subject { SommQuiz::Question.new dummy_question }


  describe "initialize" do
    def check_for_error(exception)
      expect(Proc.new{subject}).to raise_error(exception)
    end

    it "requires a subject" do
      dummy_question.delete :subject
      check_for_error(SommQuiz::NoSubjectError)
    end

    it "converts subject to String" do
      expect(subject.subject).to be_a(String)
    end

    it "requires answers" do
      dummy_question.delete :answers
      check_for_error(SommQuiz::NoAnswersError)
    end

    it "requires answers to be an array" do
      dummy_question[:answers] = "Enzo"
      check_for_error(SommQuiz::NoAnswersError)
    end

    it "requires at least two answers" do
      dummy_question[:answers].delete_at(0)
      check_for_error(SommQuiz::NoAnswersError)
    end

    it "requires each answer to have the option key" do
      dummy_question[:answers][0].delete(:option)
      check_for_error(SommQuiz::MalformedAnswerError)
    end

    it "requires each answer to have the option key" do
      dummy_question[:answers][0].delete(:correct)
      check_for_error(SommQuiz::MalformedAnswerError)
    end

    it "requires at least one answer to be correct" do
      dummy_question[:answers][0][:correct] = false
      check_for_error(SommQuiz::MissingCorrectAnswerError)
    end

    it "requires a correct message" do
      dummy_question.delete :correct
      check_for_error(SommQuiz::MissingCorrectMessageError)
    end

    it "requires an incorrect message" do
      dummy_question.delete :incorrect
      check_for_error(SommQuiz::MissingIncorrectMessageError)
    end
  end

  describe "to_json" do
    it "does not crash" do
      expect(Proc.new { subject.to_json }).not_to raise_error
    end
  end
end
