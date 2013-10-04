require __dir__ + "/spec_helper"
require File.join(File.dirname(__FILE__) + "/../lib/models")

describe Grape do
  describe "sample_regional" do
    subject { Grape.sample_regional("Puglia", 4) }
    let(:one_grape) { Grape.sample_regional("Puglia") }

    it "gets 1 grape by default" do
      expect(one_grape.size).to eq(1)
    end
  end
end
