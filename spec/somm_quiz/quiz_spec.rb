require __dir__ + "/../../lib/somm_quiz"

describe SommQuiz::Quiz do
  describe "new" do
    subject { SommQuiz::Quiz.new }

    it "selects 20 topics" do
      expect(subject.topics.size).to eq(20)
    end

    it "selects topics that are truly SommQuiz::Topics" do
      subject.topics.each do |topic|
        expect(topic).to be_a(SommQuiz::Topic::Base)
      end
    end

    it "selects a type of question for each topic" do
      expect(subject.questions.size).to eq(subject.topics.size)
    end

    it "fills @questions with real questions" do
      subject.questions.each do |question|
        expect(question).to be_a(SommQuiz::Question)
      end
    end
  end
end
