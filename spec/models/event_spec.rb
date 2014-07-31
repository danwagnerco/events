require 'spec_helper'

describe "An event" do
    
  it "is free if the price is $0" do
    event = Event.new(price: 0)
    
    expect(event).to be_free
  end
  
  it "is not free if the price is non-$0" do
    event = Event.new(price: 10)
    
    expect(event).not_to be_free    
  end
  
  it "requires a name" do
    event = Event.new(name: "")
    
    event.valid? # populates errors
    
    expect(event.errors[:name].any?).to be_true
  end
  
  it "requires a description" do
    event = Event.new(description: "")
    
    event.valid?
    
    expect(event.errors[:description].any?).to be_true
  end
  
  it "requires a location" do
    event = Event.new(location: "")
    
    event.valid?

    expect(event.errors[:location].any?).to be_true
  end
  
  it "requires a description over 24 characters" do
    event = Event.new(description: "X" * 24)
    
    event.valid?

    expect(event.errors[:description].any?).to be_true
  end
  
  it "accepts a $0 price" do
    event = Event.new(price: 0.00)

    event.valid?

    expect(event.errors[:price].any?).to be_false
  end
  
  it "accepts a positive price" do
    event = Event.new(price: 10.00)

    event.valid?

    expect(event.errors[:price].any?).to be_false
  end
  
  it "rejects a negative price" do
    event = Event.new(price: -10.00)

    event.valid?

    expect(event.errors[:price].any?).to be_true
  end
  
  it "rejects a 0 capacity" do
    event = Event.new(capacity: 0)

    event.valid?

    expect(event.errors[:capacity].any?).to be_true
  end
  
  it "accepts a positive capacity" do
    event = Event.new(capacity: 5)

    event.valid?

    expect(event.errors[:capacity].any?).to be_false
  end
  
  it "rejects a negative capacity" do
    event = Event.new(capacity: -5)

    event.valid?

    expect(event.errors[:capacity].any?).to be_true
  end
  
  it "rejects a non-integer capacity" do
    event = Event.new(capacity: 3.14159)

    event.valid?

    expect(event.errors[:capacity].any?).to be_true
  end
  
  it "accepts properly formatted image file names" do
    file_names = %w[e.png event.png event.jpg event.gif EVENT.GIF]
    file_names.each do |file_name|
      event = Event.new(image_file_name: file_name)
      event.valid?
      expect(event.errors[:image_file_name].any?).to be_false
    end
  end
  
  it "reject improperly formatted image file names" do
    file_names = %w[event .jpg .png .gif event.pdf event.doc]
    file_names.each do |file_name|
      event = Event.new(image_file_name: file_name)
      event.valid?
      expect(event.errors[:image_file_name].any?).to be_true
    end
  end
  
  it "with example attributes is valid" do
    event = Event.new(event_attributes)
    
    expect(event.valid?).to be_true
  end
  
  it "has many registrations" do
    event = Event.new(event_attributes)
    
    registration1 = event.registrations.new(registration_attributes)
    registration2 = event.registrations.new(registration_attributes)
        
    expect(event.registrations).to include(registration1)
    expect(event.registrations).to include(registration2)
  end
  
  it "deletes associated registrations" do
    event = Event.create!(event_attributes)
    
    event.registrations.create!(registration_attributes)
    
    expect { 
      event.destroy
    }.to change(Registration, :count).by(-1)
  end
  
  it "is sold out if no spots are left" do
    event = Event.new(event_attributes(capacity: 0))

    expect(event.sold_out?).to be_true
  end
  
  it "is not sold out if spots are available" do
    event = Event.new(event_attributes(capacity: 10))

    expect(event.sold_out?).to be_false
  end
  
  it "decrements spots left when a registration is created" do
    event = Event.create!(event_attributes)
    
    event.registrations.create!(registration_attributes)
    
    expect { 
      event.registrations.create!(registration_attributes)
    }.to change(event, :spots_left).by(-1)
  end
  
  context "upcoming query" do
    it "returns the events with a starts at date in the future" do
      event = Event.create!(event_attributes(starts_at: 3.months.from_now))

      expect(Event.upcoming).to include(event)
    end

    it "does not return events with a starts at date in the past" do
      event = Event.create!(event_attributes(starts_at: 3.months.ago))

      expect(Event.upcoming).not_to include(event)
    end

    it "returns upcoming events ordered with the soonest event first" do
      event1 = Event.create!(event_attributes(starts_at: 3.months.from_now))
      event2 = Event.create!(event_attributes(starts_at: 2.months.from_now))
      event3 = Event.create!(event_attributes(starts_at: 1.month.from_now))

      expect(Event.upcoming).to eq([event3, event2, event1])
    end
  end
  
end
