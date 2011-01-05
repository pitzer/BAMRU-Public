def rand2() srand.to_s[0..1]; end
def rand3() srand.to_s[0..2]; end
def rand4() srand.to_s[0..3]; end

Factory.define :event do |u|
  u.kind        "Normal" 
  u.title       { "U#{rand4}" } 
  u.location    { "L#{rand4}" } 
  u.leaders     "hi"
  u.start
  u.end
  u.description "Big Hello"
end

