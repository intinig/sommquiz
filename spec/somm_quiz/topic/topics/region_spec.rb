require __dir__ + "/../../../../lib/somm_quiz"
require __dir__ + "/../../../../lib/models"

describe SommQuiz::Topic::Region do
  describe "availability" do
    subject { SommQuiz::Topic::Region.availability }

    it "returns all regions" do
      expect(subject).to eq(Region.count)
    end
  end

  describe "initialize" do
    it "sets name to a region name" do
      expect(SommQuiz::Topic::Region.new.name).not_to be_nil
    end

    it "accepts the exclude option and honors it" do
      regions = Region.all.map {|r| r.name}
      regions.delete("Puglia")
      expect(SommQuiz::Topic::Region.new(:exclude => regions).name).to eq("Puglia")
    end
  end

  describe "ask" do
    subject { SommQuiz::Topic::Region.new.ask }

    it "returns a Question" do
      expect(subject).to be_a(SommQuiz::Question)
    end
  end
end
