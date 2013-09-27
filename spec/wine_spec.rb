require_relative '../lib/models'
require_relative '../lib/utilities'

describe Wine do
  describe "random" do
    def default_options(options = {})
      {
        :easy_by_region => true,
        :denominations => ["DOC", "DOCG", "DOP", "IGP"],
        :upper_grapes_limit => 0,
        :lower_grapes_limit => 0
      }.merge(options)
    end
    it "does not bomb out if you ask more wines than possible" do
      Wine.random(100000, default_options).size.should == Wine.count
    end

    it "gives everything if you tell it to return 0" do
      Wine.random(0, default_options).size.should == Wine.count
    end

    it "gives only DOC and DOCG wines by default" do
      Wine.random(0, default_options(:denominations => nil)).size.should == Wine.count(:denomination => Denomination.all(:name => ["DOC", "DOCG"]))
    end

    it "should exclude wines that contain a region name" do
      easy_wines = Wine.random(0, default_options(:denominations => nil))
      complex_wines = Wine.random(0, default_options(:easy_by_region => false, :denominations => nil))
      (easy_wines.size - complex_wines.size).should == SommQuiz::Utilities.count_wines_with_region_in_their_name
    end

    it "excludes wines that contain the name of the grape" do
      easy_wines = Wine.random(0, default_options(:denominations => nil))
      complex_wines = Wine.random(0, default_options(:exclude_grape_wines => true, :denominations => nil))
      (easy_wines.size - complex_wines.size).should == SommQuiz::Utilities.count_wines_with_grapes_in_their_name
    end

    it "always gives a sufficient number of wines" do
      wines = Wine.random(20,
        :denominations => ["DOCG", "DOC"],
        :lower_grapes_limit => 3
        )
      wines.size.should == 20
    end
  end
end
