require File.join(File.dirname(__FILE__) + "/../lib/quiz")
require File.join(File.dirname(__FILE__) + "/../lib/utilities")

describe Quiz do
  describe "sample_wines" do
    it "does not bomb out if you ask more wines than possible" do
      Quiz.sample_wines(100000, :easy_by_region => true, :denominations => ["DOC", "DOCG", "DOP", "IGP"]).size.should == Wine.count
    end

    it "gives only DOC and DOCG wines by default" do
      Quiz.sample_wines(100000, :easy_by_region => true).size.should == Wine.count(:denomination => Denomination.all(:name => ["DOC", "DOCG"]))
    end

    it "should exclude wines that contain a region name" do
      easy_wines = Quiz.sample_wines(10000, :easy_by_region => true)
      complex_wines = Quiz.sample_wines(10000, :easy_by_region => false)
      (easy_wines.size - complex_wines.size).should == SommQuiz::Utilities.count_wines_with_region_in_their_name
    end
  end

  describe "grapes_question" do

  end
end
