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
    subject do
      r = SommQuiz::Topic::Region.new
      r.instance_variable_set(:@data, Region.first(:name => 'Lombardia'))
      r.instance_variable_set(:@name, 'Lombardia')
      r
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
      subject.instance_variable_set(:@data, Region.first(:name => 'Liguria'))
      subject.instance_variable_set(:@name, 'Liguria')
      expect(subject.question_types).not_to include('which_wine')
    end
  end

  describe "which_wine_fetch_correct" do
    let(:all_regions) do
      double(SommQuiz::Topic::Manager, :available_topics => [SommQuiz::Topic::Region])
      SommQuiz::Topic::Manager.random
    end

    let(:region) do
      r = SommQuiz::Topic::Region.new
      r.instance_variable_set(:@data, Region.first(:name => 'Lombardia'))
      r.instance_variable_set(:@name, 'Lombardia')
      r
    end

    subject { region.which_wine_fetch_correct }

    # Warning: this is supposed to be long it has to work on all 74 DOCGS
    it "chooses a wine that does not have a region in its name" do
      all_regions.each do |region|
        next if region.excluded_regions_from_which_wine.include?(region.name)
        expect(region.which_wine_fetch_correct).not_to match(/#{region.name}/i)
      end
    end

    it "chooses a wine from that region" do
      region_data = Region.first(:name => region.name)
      region_wines = region_data.wines
      expect(region_data.wines.map {|w| w.name}).to include(subject)
    end

    it "memoizes the answer" do
      expect(subject).to eq(region.which_wine_fetch_correct)
    end
  end

  describe "which_wine_fetch_incorrect" do
    let(:region) do
      r = SommQuiz::Topic::Region.new
      r.instance_variable_set(:@data, Region.first(:name => 'Lombardia'))
      r.instance_variable_set(:@name, 'Lombardia')
      r
    end

    subject { region.which_wine_fetch_incorrect}

    it "gives 4 options" do
      subject.size.should == 4
    end

    it "gives only wine names as answers" do
      subject.each do |wine|
        expect(Wine.all(:name => wine)).not_to be_empty
      end
    end

    it "does not suggest wines that are from that region" do
      subject.each do |wine|
        expect(Wine.first(:name => wine).region.name).not_to eq(region.name)
      end
    end
  end
end
