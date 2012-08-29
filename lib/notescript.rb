class NoteScript
  def initialize(email, notes)
    @email = email
    @notes = notes
    @persons = Highrise::Person.all
  end

  def run
    find_person

    @found_person.nil? ? create_person : find_notes

    create_notes
  end

  private

  def create_notes
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

  def find_notes
    @found_person.notes.each do |p|
      @notes.delete_if { |n| true if n == p.body } # REVIEW
    end
  end
end