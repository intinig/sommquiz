require __dir__ + "/../../../spec_helper"
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
      regions = Region.get_all
      regions.delete("Puglia")
      expect(SommQuiz::Topic::Region.new(:exclude => regions).name).to eq("Puglia")
    end
  end

  describe "ask" do
    subject do
      r = SommQuiz::Topic::Region.new
    end

    it "returns a Question" do
      expect(subject.ask).to be_a(SommQuiz::Question)
    end

    it "picks a question-type" do
      expect(subject).to receive(:pick_question_type).and_return('which_wine')
      subject.ask
    end

    it "picks a subject" do
      expect(subject).to receive(:pick_subject).and_return(subject.pick_subject('which_wine'))
      subject.ask
    end
  end

  describe "pick subject" do
    subject { SommQuiz::Topic::Region.new }

    it "returns a non-empty string" do
      expect(subject.pick_subject(subject.pick_question_type).to_s).not_to eq("")
    end

    it "exclude non-DOCG regions from wine questions" do
      subject.instance_variable_set(:@name, 'Liguria')
      expect(subject.question_types).not_to include('which_wine')
    end
  end

  describe "which_wine_fetch_correct" do
    let(:region) do
      r = SommQuiz::Topic::Region.new
      r.instance_variable_set(:@name, "Lombardia")
      r
    end

    subject { region.which_wine_fetch_correct }

    it "chooses a wine from that region" do
      expect(Wine.get_region(subject)).to eq(region.name)
    end

  end

  describe "which_wine_fetch_incorrect" do
    let(:region) do
      SommQuiz::Topic::Region.new
    end

    subject { region.which_wine_fetch_incorrect}

    it "gives 4 options" do
      subject.size.should == 4
    end

    it "gives only wine names as answers" do
      subject.each do |wine|
        expect(Wine.exists?(wine)).to be_true
      end
    end

    it "does not suggest wines that are from that region" do
      subject.each do |wine|
        expect(Wine.get_region(wine)).not_to eq(region.name)
      end
    end
  end
end
