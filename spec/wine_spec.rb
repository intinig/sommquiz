require __dir__ + "/spec_helper"
require_relative '../lib/models'
require_relative '../lib/utilities'

describe Wine do
  describe "count_with_grapes" do
    it "returns a number" do
      expect(Wine.count_with_grapes.to_i).to eq(Wine.count_with_grapes)
    end

    it "returns a number greater than 0" do
      expect(Wine.count_with_grapes).to be > 0
    end
  end

  describe "has_grapes_in_name?" do
    let(:montepulciano) { Wine.first :name => "Montepulciano d'Abruzzo DOC"}
    let(:chianti) { Wine.first :name => "Chianti DOCG"}

    it "returns true if wine has grapes in name" do
      ActiveSupport::Deprecation.silence do
        expect(montepulciano.has_grapes_in_name?).to be_true
      end
    end

    it "returns false if wine doesn't have grape in name" do
      ActiveSupport::Deprecation.silence do
        expect(chianti.has_grapes_in_name?).not_to be_true
      end
    end
  end

  describe "sample_outside_region" do
    subject { Wine.sample_outside_region("Calabria") }

    it "returns an array" do
      expect(Proc.new { subject.to_ary }).not_to raise_error
    end

    it "returns an array of wine names" do
      subject.each do |w|
        expect(Wine.get_all).to include(w)
      end
    end
  end

  describe "get_all" do
    subject { Wine.get_all }
    let(:all_wine_names) { Wine.all.map {|w| w.name}}

    it "returns an array" do
      expect(Proc.new { subject.to_ary }).not_to raise_error
    end

    it "has all wines inside it" do
      ActiveSupport::Deprecation.silence do
        subject.each do |w|
          expect(all_wine_names).to include(w)
        end
      end
    end
  end

  it "should set a region on every wine" do
    Wine.get_all.each do |w|
      expect(Wine.get_region(w)).not_to be_nil
    end
  end
end
