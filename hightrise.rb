#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'

require 'highrise'

class NoteScript
  def initialize(email)
    @email = email
    @persons = Highrise::Person.all
    @flag = true
  end

  def run
    find_person
    create_person if @found_person.nil?

    find_notes(@found_person)
    create_notes(@found_person) if @found_notes.nil?
  end

  private

  def create_notes(user)
      puts "No notes found. Creating notes: "
      add_note(NOTE1, user)
      add_note(NOTE2, user)
      puts "Finished!"
  end

  def add_note(body, user)
      note = user.add_note
      note.body = body
      note.save
      puts "...#{note.body}..."
  end

  def find_user_by_email(person, emails)
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
      if (emails.empty? == false)
          find_user_by_email(p, emails)
      end
    end
  end

  def create_person
    puts "No users found. Creating new user with email #{@email}"
    new_person = Highrise::Person.create(:first_name => @email.split('@').first)
    new_person.contact_data.email_addresses = [:address => @email, :location => "Work"]
    new_person.save
    @found_person = new_person
  end

  def find_notes(person)
    person.notes.each do |n|
      if n.body == NOTE1
        @flag_1 = true
      end

      if n.body == NOTE2
        @flag_2 = true
      end

      if (@flag_1 == true && @flag_2 == true)
        puts "Notes found. All right."
        @found_notes = "something"
      end
    end
  end
end

Highrise::Base.site = 'https://fsateam.highrisehq.com'
Highrise::Base.user = '016387efef4dd406559aaec5696feae5'
Highrise::Base.format = :xml

NOTE1 = "note one blah-blah-blah"
NOTE2 = "ko-ko-ko kudah-tah-tah"

n = NoteScript.new("user190@example.com")
n.run