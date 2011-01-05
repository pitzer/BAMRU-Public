# ----- Remove all old data
puts "Wiping out old data"
Event.all.each {|e| e.destroy}

puts "Creating new data"
20.times { Factory(:event, :kind => "meeting")                            }
20.times { Factory(:event, :kind => "training")                           }
20.times { Factory(:event, :kind => "event")                              }
20.times { Factory(:event, :kind => "non county meeting")                 }

10.times { Factory(:event, :kind => "meeting",            :end => randE ) }
10.times { Factory(:event, :kind => "training",           :end => randE ) }
10.times { Factory(:event, :kind => "event",              :end => randE ) }
10.times { Factory(:event, :kind => "non county meeting", :end => randE ) }
