#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'

require 'highrise'

module HighriseContactCreator

  class Contact

    def initialize(email, loc)
      @contact = Highrise::Person.search(:email => email)[0] || 
                 Highrise::Person.create(:first_name => email, 
                              :contact_data => { :email_addresses => [ 
                              :address => email, :location => loc ]})
      @notes = all_notes
    end

    def find_note(note)
      @notes.include?(note)
    end

    def all_notes
      @contact.notes.map { |note| note.body  }
    end

    def create_all(notes)
      notes.each do |note|
        new_note(note) unless find_note(note)
      end
    end

    def new_note(note)
      Note.new(@contact, note)
      note
    end
  end
  
  class Note

    def initialize(contact, note)
      contact.add_note( :body => note, :visible_to => "NamedGroup", :group_id => ARGV[2])
    end
  end
end

module HighriseContactCreator

  def self.setup!(site, user)
    Highrise::Base.site = site
    Highrise::Base.user = user
    Highrise::Base.format = :xml
  end

  def self.process(notes, email)
    contact = Contact.new(email, "Work")
    contact.create_all(notes)
   # Note.new(contact).create_all
  end
end

notes = ["note1", "note2"]
email = "mail@gmail.com"

HighriseContactCreator.setup!(ARGV[0], ARGV[1]) || raise("User should be specified")
HighriseContactCreator.process(notes, email)
