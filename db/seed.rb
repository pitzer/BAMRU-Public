# ----- Remove all old data
puts "Wiping out old data"
Event.all.each {|e| e.destroy}

puts "Creating new data"
10.times { Factory(:event, :kind => "meeting")                    }
7.times  { Factory(:event, :kind => "training")                   }
3.times  { Factory(:event, :kind => "event")                      }
3.times  { Factory(:event, :kind => "non_county")                 }

3.times  { Factory(:event, :kind => "training",   :end => randE ) }
2.times  { Factory(:event, :kind => "event",      :end => randE ) }
