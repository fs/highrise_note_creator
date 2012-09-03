class HighriseCreator
  def initialize(site, user, params)
    Highrise::Base.site = site
    Highrise::Base.user = user
    Highrise::Base.format = :xml
    @visible_to = "Everyone"
    @group_id = nil
    parse_parameters(params)
  end

  def create
    @person = Highrise::Person.search(:email => @email).first
    if @person.nil?
      create_person
      create_notes
    else
      create_notes
    end
  end

  private

  def parse_parameters(argv)
    argv.each do |arg|
      case arg
      when '-g'
        @visible_to = "NamedGroup"
        @group_name = ARGV.delete_at(ARGV.index(arg)+1)
        ARGV.delete(arg)
        set_group_id
      end
    end
    @email = argv.shift
    @notes = argv
  end

  def set_group_id
    Highrise::Group.all.each do |group|
      @group_id = group.id if @group_name == group.name
    end
  end

  def create_person
    @person = Highrise::Person.new(:first_name => @email, :contact_data => {})
    @person.contact_data = {"email-addresses" => {"email-address" => {"address" => @email, "location" => "work"}}}
    @person.save
  end

  def create_notes
    @notes.each do |note|
      if @person.notes.all? { |pnote| pnote.body.downcase != note.downcase }
        Highrise::Note.new("body"=>note,
          "subject_id"=>@person.id,
          "subject_type"=>"Party",
          "visible_to"=>@visible_to,
          "group-id" => @group_id).save
      else
        @person.notes.each do |pnote|
          if pnote.body.downcase == note.downcase
            pnote.update_attributes("group_id"=>@group_id, "visible_to"=>@visible_to ) 
          end
        end
      end
    end
  end
end
