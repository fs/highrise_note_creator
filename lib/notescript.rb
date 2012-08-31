class NoteScript
  def self.setup_highrise(site, user)
    Highrise::Base.site = site
    Highrise::Base.user = user
    Highrise::Base.format = :xml
  end
  
  def initialize(email, notes)
    @email, @notes = email, notes
  end

  def create!
    @person = find_person || create_person
    create_notes
  end

  private

  def persons
    @persons ||= Highrise::Person.all
  end

  def find_person
    persons.each do |person|
      if person.contact_data.email_addresses.find { |email| email.address == @email }
        puts "Person found with email #{@email}"
        return person
      end
    end
    
    nil
  end
  
  def create_person
    puts "No person found. Creating new person with email #{@email}"
    
    Highrise::Person.create(
      :first_name => @email.split('@').first,
      :contact_data => {
        :email_addresses => [:address => @email, :location => 'Work']
      }
    )
  end  
  
  def person_notes
    @person_notes ||= @person.notes.map{ |note| note.body }
  end  
  
  def create_notes
    @notes.each do |note, group_name| 
      create_note(note, group_name) unless note_exists?(note)
    end
  end
  
  def create_note(body, group_name)
    note = @person.add_note(:body => body, :visible_to => group_name ? "NamedGroup" : "Everyone", :group_id => get_group_id(group_name))
    
    puts "...#{note.body}..."
  end
  
  def get_group_id(group_name)
     Highrise::Group.all.find { |group| return group.id if group.name == group_name }
  end
  
  def note_exists?(note)
    person_notes.include?(note)
  end 
end