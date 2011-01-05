# ----- Remove all old data
puts "Wiping out old data"
Event.all.each {|e| e.destroy}

puts "Creating new data"
e1 = Factory(:event, :kind => "meeting")
e2 = Factory(:event, :kind => "training")
e3 = Factory(:event, :kind => "event")
e4 = Factory(:event, :kind => "non county meeting")
