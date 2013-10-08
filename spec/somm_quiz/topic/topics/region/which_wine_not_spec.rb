require __dir__ + "/../../../../spec_helper"
require __dir__ + "/../../../../../lib/somm_quiz"

describe SommQuiz::Topic::RegionExtensions::WhichWineNot do
  subject { SommQuiz::Topic::Region.new }

  describe "which_wine_not_original_region" do
    it "returns a region name" do
      expect(Object::Region.get_all).to include(subject.which_wine_not_original_region)
    end
  end

end
