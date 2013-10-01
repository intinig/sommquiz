require __dir__ + "/../../../lib/somm_quiz"

describe SommQuiz::Topic::Base do
  describe "==" do
    module SommQuiz
      module Topic
        class Fake < Base
          def initialize(name)
            @name = name
          end
        end

        class FakeGrape < Fake
        end

        class FakeRegion < Fake
        end
      end
    end

    let(:montepulciano) { SommQuiz::Topic::FakeGrape.new("Montepulciano") }
    let(:montpellier) { SommQuiz::Topic::FakeGrape.new("Montepulciano") }
    let(:chianti) { SommQuiz::Topic::FakeGrape.new("Chianti") }
    let(:fake_chianti) { SommQuiz::Topic::FakeRegion.new("Chianti") }

    it "is true if operands have the same type and same name" do
      expect(montepulciano == montpellier).to be_true
    end

    it "is false if operands have different types" do
      expect(chianti == fake_chianti).to be_false
    end

    it "is false if operands have different names" do
      expect(montepulciano == chianti).to be_false
    end
  end
end
