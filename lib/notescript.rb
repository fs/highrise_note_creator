class NoteScript
  def initialize(email, notes)
    @email = email
    @notes = notes
  end

  def run
    find_notes(find_person)
  end

  private

  def persons
    @persons ||= Highrise::Person.all
  end

  def find_person
    persons.each do |p|
      if !p.contact_data.email_addresses.find{|e| e.address == @email}.nil? # если нашли соответствующий email, то возвращаем его юзера
        puts "Person found with email #{@email}"
        return p
      end
    end
    nil
  end

  def find_notes(person)
    return create_person if person.nil? # Если пользователь не найден, то создаем его (return нужен, чтобы не парсить notes, т.к. у только что созданного юзера их нет)
    person.notes.each do |p|
      @notes.delete_if { |n| true if n == p.body } # ремувим те note, которые у юзера уже имеются
    end
    add_notes(person)
  end

  def create_person
    puts "No person found. Creating new person with email #{@email}"
    new_person = Highrise::Person.create(:first_name => @email.split('@').first)
    new_person.contact_data.email_addresses = [:address => @email, :location => "Work"]
    new_person.save
    add_notes(new_person)
  end

  def add_notes(person)
    @notes.each do |n|
      puts "No note found. Creating note: "
      add_note(n, person)
      puts "Finished!"
    end
    puts "Everything is up to date!" if @notes.empty? # ничего не добавлено - у юзера все notes уже есть
  end

  def add_note(body, person)
    note = person.add_note
    note.body = body
    note.save
    puts "...#{note.body}..."
  end
end