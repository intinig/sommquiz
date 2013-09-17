require 'ap'
require File.join(File.dirname(__FILE__), "/models")

def check_for_grapes
  Wine.docg.all.each do |wine|
    ap wine.id.to_s + " - " + wine.name if wine.split_grapes.empty?
  end

  Wine.doc.all.each do |wine|
    ap wine.id.to_s + " - " + wine.name if wine.split_grapes.empty?
  end
end

def debug_grapes
  Wine.doc.all.each do |wine|
    if wine.split_grapes.empty?
      ap wine.id
      ap wine.name
      ap wine.grapes
      break
    end
  end
end

debug_grapes
