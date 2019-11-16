# TODO: Write documentation for `CGSTestApp`
require "../src/geo"

module CGSTestApp
  VERSION = "0.1.0"

  # TODO: Put your code here
  peter = Person.new "Peter"
  dog1 = Dog.new "dog1", peter
  puts dog1.owener.name
end
