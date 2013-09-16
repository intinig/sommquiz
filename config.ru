require 'rubygems'
require 'bundler/setup'

require 'sinatra'

require File.join(File.dirname(__FILE__), '/app')

run Sinatra::Application
