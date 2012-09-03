#!/usr/bin/env ruby
#Username:asdasdaf password:123456

require 'highrise'
require File.dirname(__FILE__)+'/lib/highrisecreator'

site = 'https://namelast.highrisehq.com'
user = '2aa2648366d4aede1bdbce5531149012'
params = ARGV 

pers = HighriseCreator.new(site, user, params)
pers.create


