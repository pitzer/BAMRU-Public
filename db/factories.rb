def rand2() srand.to_s[0..1]; end
def rand3() srand.to_s[0..2]; end
def rand4() srand.to_s[0..3]; end
def randM() 1 + rand(12); end
def randD() 1 + rand(28); end
def randE() "2011-#{randM}-#{randD}"; end

Factory.define :event do |u|
  u.kind        "event" 
  u.title       { "U#{rand4}" } 
  u.location    { "L#{rand4}" } 
  u.leaders     { "Joe#{rand4}" }
  u.start       { randE }
  u.end
  u.description { "Big Hello #{rand4}" }
end

