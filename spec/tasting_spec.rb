require __dir__ + "/spec_helper"
require_relative '../lib/models'

describe Tasting do
  it "should answer to chained selectors" do
    Proc.new{ Tasting.new.visivo.limpidezza }.should_not raise_error
  end

  describe "limpidezza" do
    it "should return stuff as if it was an object" do
      Tasting.new.visivo.limpidezza.size.should == 5
    end
  end
end
