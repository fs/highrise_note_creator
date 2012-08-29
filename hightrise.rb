#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'

require 'highrise'

Highrise::Base.site = 'https://rf1.highrisehq.com'
Highrise::Base.user = '118afb46d954bf7b1e14f36d8df5a7c1'
Highrise::Base.format = :xml

class People


  def add_new(email)
    @contact = Highrise::Person.new(:first_name => email, :contact_data => {})
    @contact.contact_data = {"email-addresses" => {"email-address" => {"address" => email, "location" => "work"}}}
    @contact.save
    return self
  end
  
  def initialize()
    @contact =""
  end

  def link(email)
    @contact = Highrise::Person.search(:email => email)[0]
    return self
  end

  def notes()
    @contact.notes
  end

  def notes?()
    !@contact.notes.nil?
  end

  def note_add(note)
    new_note = @contact.add_note
    new_note.body = note
    new_note.save
  end

  def note_exist?(note)
    @contact.notes.each do |n|
      return true if n.body == note
    end
    return false
  end
end

def contact_exist(email)
    Highrise::Person.search(:email => email)==[] ? false : true
end

NOTES = ['note1', 'note2']
email="robert@singer.com"
new_contact = People.new()
if contact_exist(email)
  new_contact.link(email)
  puts "Find contact!"
else
  new_contact.add_new(email)
  puts "Contact is new"
end
NOTES.each do |note|
unless new_contact.note_exist?(note)
  new_contact.note_add(note)
  puts "#{note} -- Note added"
end
end
