#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'

require 'highrise'

require 'lib/notescript'

Highrise::Base.site = 'https://fsateam.highrisehq.com'
Highrise::Base.user = '016387efef4dd406559aaec5696feae5'
Highrise::Base.format = :xml

notes = ['note one blah-blah-blah', 'ko-ko-ko kudah-tah-tah']

n = NoteScript.new("user200@example.com", notes)
n.run