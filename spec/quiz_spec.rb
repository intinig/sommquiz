require File.join(File.dirname(__FILE__) + "/../lib/quiz")
require File.join(File.dirname(__FILE__) + "/../lib/utilities")

describe Quiz do
  describe "build_grapes_question_with_wine" do
    it "returns unique answers" do
      wine = Wine.first
      answers = Quiz.build_grapes_question_with_wine(wine)["a"].map{|x| x["option"]}
      answers.should == answers.uniq
    end

    it "returns 4 answers" do
      wine = Wine.first
      answers = Quiz.build_grapes_question_with_wine(wine)["a"]
      answers.size.should == 4
    end
  end

  describe "region_question" do
    it "defaults to 1 question" do
      Quiz.region_question.size == 1
    end
  end
end
