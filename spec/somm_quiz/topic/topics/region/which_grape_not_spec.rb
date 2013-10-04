require __dir__ + "/../../../../spec_helper"
require __dir__ + "/../../../../../lib/somm_quiz"

describe SommQuiz::Topic::RegionExtensions::WhichGrapeNot do
  subject { SommQuiz::Topic::Region.new }

  describe "which_grape_not_fetch_correct" do
    it "returns a name" do
      expect(subject.which_grape_not_fetch_correct).not_to be_nil
    end
  end

  describe "which_grape_not_fetch_incorrect" do
    it "returns an array" do
      expect(subject.which_grape_not_fetch_incorrect).to respond_to(:to_ary)
      expect(subject.which_grape_not_fetch_incorrect).not_to be_empty
    end
  end

  describe "which_grape_not_answers" do
    it "returns an array" do
      expect(subject.which_grape_not_answers).to respond_to(:to_ary)
      expect(subject.which_grape_not_answers).not_to be_empty
      expect(subject.which_grape_not_answers.map{|x| x[:correct]}).to include(false)
    end
  end
end
