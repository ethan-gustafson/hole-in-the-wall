# The Bundler runtime allows its two main methods, Bundler.setup and Bundler.require, 
# to limit their impact to particular groups.
require 'bundler/setup'
# .require requires all of the gems in the specified groups.
Bundler.require

require 'sinatra/base'
require 'sinatra/flash'
require 'time'
require 'pry'

require_all 'app'