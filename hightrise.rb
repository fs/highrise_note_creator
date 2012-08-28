#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'

require 'highrise'

class NoteScript
  def initialize(email)
    @email = email
    @persons = Highrise::Person.all
    @NOTES = NOTES
  end

  def run
    find_person

    @found_person.nil? ? create_person : find_notes
    
    add_all_notes
  end

  private

  def create_notes(body)
      puts "No note found. Creating note: "
      add_note(body)
      puts "Finished!"
  end

  def add_note(body)
      note = @found_person.add_note
      note.body = body
      note.save
      puts "...#{note.body}..."
  end

  def find_email_in_user(person, emails)
    emails.each do |e|
      if (e.address == @email)
        puts "User found with email #{@email}"
        @found_person = person
      end
    end
  end

  def find_person
    @persons.each do |p|
      emails = p.contact_data.email_addresses
      unless emails.empty?
          find_email_in_user(p, emails)
          break unless @found_person.nil?
      end
    end
  end

  def create_person
    puts "No user found. Creating new user with email #{@email}"
    new_person = Highrise::Person.create(:first_name => @email.split('@').first)
    new_person.contact_data.email_addresses = [:address => @email, :location => "Work"]
    new_person.save
    @found_person = new_person
  end

  def add_all_notes
    @NOTES.each do |n|
      create_notes(n)
    end
    puts "Everything up to date!" if @NOTES.empty?
  end

  def find_notes
    @found_person.notes.each do |p|
      @NOTES.delete_if { |n| true if n == p.body } # REVIEW
    end
  end
end

Highrise::Base.site = 'https://fsateam.highrisehq.com'
Highrise::Base.user = '016387efef4dd406559aaec5696feae5'
Highrise::Base.format = :xml

NOTES = ['note one blah-blah-blah', 'ko-ko-ko kudah-tah-tah']

n = NoteScript.new("user190@example.com")
n.run