require 'factory_girl'

def rand2() srand.to_s[0..1]; end
def rand3() srand.to_s[0..2]; end
def rand4() srand.to_s[0..3]; end
def randM() 1 + rand(12); end
def randD() 1 + rand(28); end
def randE() "2011-#{randM}-#{randD}"; end

FactoryGirl.define do
  factory :event do
    kind        "other"
    title       { "T#{rand4}" }
    location    { "L#{rand4}" }
    leaders     { "Leader#{rand4}" }
    start       { randE }
    #finish
    description { "Big Hello #{rand4}" }
  end
end

