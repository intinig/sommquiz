require_relative '../lib/models'
require_relative '../lib/utilities'

describe Wine do
  describe "random" do
    def default_options(options = {})
      {
        :easy_by_region => true,
        :denominations => ["DOC", "DOCG", "DOP", "IGP"],
        :grapes_limit => 0
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
      complex_wines = Wine.random(0, default_options(:easy_by_region => false))
      (easy_wines.size - complex_wines.size).should == SommQuiz::Utilities.count_wines_with_region_in_their_name
    end

  end
end
