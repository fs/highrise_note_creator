#!/usr/bin/env ruby

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '../lib')

require 'rubygems'
require 'bundler/setup'
require 'highrise'
require 'notescript'

HIGHRISE_SITE = 'https://fsateam.highrisehq.com'
HIGHRISE_USER = '016387efef4dd406559aaec5696feae5'
NOTES = {'important!' => 'Senate', 'ko-ko-ko kudah-tah-tah' => nil}

email = ARGV.shift || raise("User should be specified")

NoteScript.setup_highrise(HIGHRISE_SITE, HIGHRISE_USER)
note = NoteScript.new(email, NOTES).create!