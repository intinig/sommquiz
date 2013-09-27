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

  describe "build_reverse_grapes_question_with_wine" do
    it "should give correct answers" do
      wines = Wine.random(0, :denominations => ["DOCG", "DOC"])
      wines = wines.select {|w| w.grapes.size > 3}
      wines.should_not be_empty
    end
  end

  describe "reverse_grapes" do
    it "should always give a correct number of questions" do
      answers = Quiz.reverse_grapes_question(20)
      answers.size.should == 20
    end
  end

  describe "region_question" do
    it "defaults to 1 question" do
      Quiz.region_question.size == 1
    end
  end

  describe "reverse region" do
    it "does not pick regions with less than 3 docg" do
      q = Quiz.reverse_region_question(21)
      threshold_regions = Denomination.first(:name => "DOCG").wines.map {|w| w.region}.group_by {|y| y}.select {|k,v| v.size > 2}.count
      q.size.should == threshold_regions # calcolato a mano
    end
  end

  describe "reverse wine" do
    it "does not give you Primitivo among the answers"
  end
end
