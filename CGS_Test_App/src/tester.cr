require "../src/geo"

class Tester
  def initialize
  end

  #if nothing wrong return 0 
  def autoTest
    #test if Geopoint and Geopolyline intersects
    if(pl_intersects)
      return 1
    end

    #test if Geopolyline and Geopolyline intersects
    if(ll_intersects)
      return 2
    end

    return 0
  end

  def pl_intersects
  end

  def ll_intersects
  end

  #read Xml to get a list of points
  def read
  end

  def display
  end
end

#below are simple writing examples, they're not to used anywhere
#for us to get familiar with crystal
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