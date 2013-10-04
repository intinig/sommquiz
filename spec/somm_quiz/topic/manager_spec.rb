require __dir__ + "/../../spec_helper"
require __dir__ + "/../../../lib/somm_quiz"
require "awesome_print"

describe SommQuiz::Topic::Manager do
  describe "load" do
    it "loads a topic" do
      expect(SommQuiz::Topic::Manager.load(:region)).to be_a(SommQuiz::Topic::Region)
    end
  end

  describe "random" do
    subject { SommQuiz::Topic::Manager.random(5) }
    let(:all_topics) { SommQuiz::Topic::Manager.random }

    it "returns an array of topics" do
      subject.each {|topic| expect(topic).to be_a(SommQuiz::Topic::Base)}
    end

    it "returns as many as I asked for" do
      expect(subject.size).to eql(5)
    end

    it "selects unique topics" do
      expected = all_topics.map {|i| "#{i.class}#{i.name}"}
      actual = expected.uniq
      expect(actual - expected).to be_empty
      expect(actual.size).to eql(expected.size)
    end

    it "returns everything you have if n is 0" do
      expect(all_topics.size).to eq(SommQuiz::Topic::Manager.count_available_subjects)
    end
  end

  describe "topics" do
    let!(:fake_available_topics) do
      module SommQuiz
        module Topic
          class Fake < Base
            def initialize(name)
              @name = name
            end
          end

          class Foo < Fake
            def self.availability
              5
            end
          end

          class Bar < Fake
            def self.availability
              8
            end
          end
        end
      end

      [SommQuiz::Topic::Foo, SommQuiz::Topic::Bar]
    end

    describe "sample_topic" do
      it "should filter by name of the chosen topic" do
        foo = SommQuiz::Topic::Foo.new "Foo"
        bar = SommQuiz::Topic::Bar.new "Bar"
        exclusions = [foo, bar]
        expect(SommQuiz::Topic::Foo).to receive(:new).with({:exclude => ["Foo"]})
        SommQuiz::Topic::Manager.sample_topic(SommQuiz::Topic::Foo, exclusions)
      end
    end

    describe "unique_subjects" do
      it "filters out unwanted subjects" do
        region_names = Object::Region.get_all
        region_names.delete "Puglia"

        first_element = SommQuiz::Topic::Region.new :exclude => region_names
        second_element = SommQuiz::Topic::Region.new :exclude => region_names

        subjects = [first_element, second_element]

        expect(SommQuiz::Topic::Manager.unique_subjects(subjects).size).to eq(1)
      end
    end

    describe "count_available_subjects" do
      subject { SommQuiz::Topic::Manager.count_available_subjects }

      it "returns the sum of all availabilities" do
        allow(Dir).to receive(:glob).and_return(["foo.rb", "bar.rb"])
        expect(subject).to eq(13)
      end
    end

    describe "available_topics" do
      subject { SommQuiz::Topic::Manager.available_topics }

      it "returns all available topics" do
        allow(Dir).to receive(:glob).and_return(["foo.rb", "bar.rb"])
        expect(subject).to eq(fake_available_topics)
      end
    end
  end
end
