# The Bundler runtime allows its two main methods, Bundler.setup and Bundler.require, 
# to limit their impact to particular groups.
require 'bundler/setup'
Bundler.require
# .require requires all of the gems in the specified groups.

require_all 'app'