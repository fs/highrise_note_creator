#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'

require 'highrise'

Highrise::Base.site = 'https://fs13.highrisehq.com'
Highrise::Base.user = '5c4a60575226ba5434ce1573adc55c3a'
Highrise::Base.format = :xml

# puts Highrise::Person.find(:all).first.contact_data.email_addresses.first.address

NOTES = ['note1', 'note2']
# find or create by email
# find or create notes
