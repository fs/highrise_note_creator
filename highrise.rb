#!/usr/bin/env ruby
#Username:asdasdaf password:123456

require 'highrise'

Highrise::Base.site = 'https://namelast.highrisehq.com'
Highrise::Base.user = '2aa2648366d4aede1bdbce5531149012'
Highrise::Base.format = :xml

def main(email,*notes)
  person = Highrise::Person.search(email: email)
  notes.flatten!
  if person.size == 0
    create_person(email,notes)
  else
    create_notes(person,notes)  
  end
end

def create_person(email,notes)
  person = Highrise::Person.new(:first_name => email, :contact_data => {}) 
  person.contact_data = {"email-addresses" => {"email-address" => {"address" => email, "location" => "work"}}}
  person.save
  if notes.size != 0
    notes.each do |note| 
      Highrise::Note.new("body"=>note, "subject_id"=>person.id, "subject_type"=>"Party", "visible_to"=>"Everyone").save
    end
  end
end

def create_notes(person,notes)
  notes.each do |note|  
    if person.first.notes.all? { |pnote| pnote.body.downcase != note.downcase}
      Highrise::Note.new("body"=>note, "subject_id"=>person.first.id, "subject_type"=>"Party", "visible_to"=>"Everyone").save
    end
  end
end

# Usage examples
#main '339@333.com'
#main '339@333.com','note3','note2'


