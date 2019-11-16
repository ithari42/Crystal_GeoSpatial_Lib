class Person
    def initialize(@name : String)
      @age = 0
    end
  
    def age
      @age
    end

    def name
      @name
    end
  end

class Dog
  def initialize(@name : String,@owener : Person)
  end

  def name
    @name
  end

  def owener
    @owener
  end
end

peter=Person.new "Peter"
dog1=Dog.new "dog1",peter
puts dog1.owener.name