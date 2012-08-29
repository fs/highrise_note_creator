class NoteScript
  def initialize(email, notes)
    @email = email
    @notes = notes
  end

  def persons
    @persons ||= Highrise::Person.all
  end

  def run
    find_person

    @found_person.nil? ? create_person : find_notes

    add_notes
  end

  private

  def add_notes
    @notes.each do |n|
      puts "No note found. Creating note: "
      add_note(n)
      puts "Finished!"
    end
    puts "Everything is up to date!" if @notes.empty?
  end

  def add_note(body)
    note = @found_person.add_note
    note.body = body
    note.save
    puts "...#{note.body}..."
  end

  def find_person_email(person, emails)
    emails.each do |e|
      if e.address == @email
        puts "Person found with email #{@email}"
        @found_person = person
      end
    end
  end

  def find_person
    persons.each do |p|
      emails = p.contact_data.email_addresses
        find_person_email(p, emails)
    end
  end

  def create_person
    puts "No person found. Creating new person with email #{@email}"
    new_person = Highrise::Person.create(:first_name => @email.split('@').first)
    new_person.contact_data.email_addresses = [:address => @email, :location => "Work"]
    new_person.save
    @found_person = new_person
  end

  def find_notes
    @found_person.notes.each do |p|
      @notes.delete_if { |n| true if n == p.body } # REVIEW
    end
  end
end