require 'active_support/inflector'
require 'awesome_print'

Dir.glob(__dir__ + '/topics/*.rb').each {|topic| require topic}

module SommQuiz
  module Topic
    module Manager
      def self.load(topic)
        "SommQuiz::Topic::#{topic.to_s.classify}".constantize.new
      end

      def self.sample_topic(topic, exclusions)
        filtered_exclusions = exclusions.select {|e| e.class == topic}
        topic.new(:exclude => filtered_exclusions.map {|f| f.name})
      end

      def self.unique_subjects(subjects)
        subjects.uniq {|e| "#{e.class}#{e.name}"}
      end

      def self.random(n = 10000, options = {})
        n = n > count_available_subjects ? count_available_subjects : n

        subjects = []
        exclude = options[:exclude] || []

        n.times do
          subjects << sample_topic(available_topics.sample, exclude)
        end

        subjects = unique_subjects(subjects)

        if subjects.size < n
          subjects << random(n - subjects.size, :exclude => (subjects + exclude))
        end

        subjects.flatten
      end

      def self.count_available_subjects
        available_topics.inject(0) {|sum, topic| sum + topic.availability}
      end

      def self.available_topics
        Dir.glob(__dir__ + '/topics/*.rb').map do |topic|
          "SommQuiz::Topic::#{File.basename(topic, ".rb").to_s.classify}".constantize
        end
      end
    end
  end
end
