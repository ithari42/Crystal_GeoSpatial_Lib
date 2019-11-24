require "../src/geo"

class Tester
  def initialize
  end

  #if nothing wrong return 0 
  def autoTest
    #test if Geopoint and Geopolyline intersects
    if(pl_intersects!=true)
      puts ["Crystal_GIS_Library Auto Test completed : fail", 1]
      return 1
    end

    #test if Geopolyline and Geopolyline intersects
    if(ll_intersects!=true)
      puts ["Crystal_GIS_Library Auto Test completed : fail", 2]
      return 2
    end

    if(pg_intersects!=true)
      puts ["Crystal_GIS_Library Auto Test completed : fail", 3]
      return 3
    end

    puts ["Crystal_GIS_Library Auto Test completed : success"]
    return 0
  end

  def pl_intersects
    p1=GeoPoint.new(18.9, 77.0, 1.0) # 73.1 N, 77.0 S, 1.0m 
    p2=GeoPoint.new(38.9, 77.0, 1.0)
    p3=GeoPoint.new(58.9, 77.0, 1.0)

    l1=GeoPolyline.new([p1, p2, p3])

    p_test1=GeoPoint.new(40,77,1.0)
    p_test2=GeoPoint.new(30,98,1.0)
    
    util=GeoUtilities2D.new
    ans1=util.intersects(p_test1, l1)
    ans2=util.intersects(p_test2, l1)

    if ans1==true && ans2==false
      return true
    end

    puts ["---point line intersection judge fail---"]
    puts [ans1, ans2]
    return false
  end

  def ll_intersects
    true
  end

  def pg_intersects
    p1=GeoPoint.new(18.9, 77.0, 1.0) # 73.1 N, 77.0 S, 1.0m 
    p2=GeoPoint.new(38.9, 107.0, 1.0)
    p3=GeoPoint.new(58.9, 77.0, 1.0)

    g1=GeoPolygon.new([p1, p2, p3])

    p_test1=GeoPoint.new(38.9, 90, 1.0)
    p_test2=GeoPoint.new(38.9, 120, 1.0)
    
    util=GeoUtilities2D.new
    #
    ans1=util.intersects(p_test1, g1)
    #puts ["g1",g1]
    ans2=util.intersects(p_test2, g1)
    #puts ["g1",g1]

    if ans1==true && ans2==false
      return true
    end

    puts ["---point polygon intersection judge fail---"]
    puts [ans1, ans2]
    return false
  end

  #read Xml to get a list of points
  def read
  end

  def display
  end
end
