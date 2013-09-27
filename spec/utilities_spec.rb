require File.join(File.dirname(__FILE__) + "/../lib/utilities")

describe SommQuiz::Utilities do
  it "should return number of grapes" do
    wine_grapes = SommQuiz::Utilities.count_wines_with_grapes_in_their_name
    wine_grapes.should > 0
  end
end
