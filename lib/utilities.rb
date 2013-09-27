require 'ap'
require_relative 'models'
module SommQuiz
  module Utilities
    def self.check_for_grapes
      Wine.docg.all.each do |wine|
        ap wine.id.to_s + " - " + wine.name if wine.split_grapes.empty?
      end

      Wine.doc.all.each do |wine|
        ap wine.id.to_s + " - " + wine.name if wine.split_grapes.empty?
      end
    end

    def self.debug_grapes
      Wine.docg.all.each do |wine|
        if wine.split_grapes.empty? || wine.grapes.empty?
          ap wine.id
          ap wine.name
          ap wine.grapes_description
          break
        end
      end

      Wine.doc.all.each do |wine|
        if wine.split_grapes.empty? || wine.grapes.empty?
          ap wine.id
          ap wine.name
          ap wine.grapes_description
          break
        end
      end
      "End"
    end

    def self.count_wines_with_region_in_their_name
      wines = Wine.all(
        :denomination => Denomination.all(:name => ["DOC", "DOCG"])
        )

      new_wines = wines.dup
      wines.each do |w|
        new_wines.delete w if w.name =~ /#{w.region.name}/i
      end

      wines.size - new_wines.size
    end

    def self.count_wines_with_grapes_in_their_name
      wines = Wine.all(
        :denomination => Denomination.all(:name => ["DOC", "DOCG"])
        )

      new_wines = wines.dup
      wines.each do |w|
        w.grapes.map{|g| g.name.downcase}.each do |grape|
          if w.name =~ /#{grape}/i
            new_wines.delete w
            break
          end
        end
      end

      wines.size - new_wines.size
    end

  end
end
