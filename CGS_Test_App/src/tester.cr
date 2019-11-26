require "../src/geo"
require "../src/kmlparser"

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

    if(lg_intersects!=true)
      puts ["Crystal_GIS_Library Auto Test completed : fail", 4]
      return 4
    end

    gg_intersects

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
    p1=GeoPoint.new(18.9, 77.0, 1.0) # 73.1 N, 77.0 S, 1.0m 
    p2=GeoPoint.new(39.0, 107.0, 1.0)
    p3=GeoPoint.new(39.0, 57.0, 1.0)
    p4=GeoPoint.new(58.9, 77.0, 1.0)

    l1=GeoPolyline.new([p1,p4])
    l2=GeoPolyline.new([p2,p3])

    util=GeoUtilities2D.new
    ans1=util.intersects(l1,l2)

    if ans1==true
      return true
    end
    false
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

  def lg_intersects
    #l=readl("/Users/xiaoxiaohui/Documents/program/crystal/Crystal_GeoSpatial_Lib/CGS_Test_App/src/bpolyline.kml")
    #l2=readl("/Users/xiaoxiaohui/Documents/program/crystal/Crystal_GeoSpatial_Lib/CGS_Test_App/src/bpolyline2.kml")
    l3=readl("/Users/xiaoxiaohui/Documents/program/crystal/Crystal_GeoSpatial_Lib/CGS_Test_App/src/apolyline.kml")
    g=readg("/Users/xiaoxiaohui/Documents/program/crystal/Crystal_GeoSpatial_Lib/CGS_Test_App/src/bpolygon.kml")
    puts ["ld",l3.@array_of_geo]
    puts ["gd",g.@array_of_geo]
    puts ["tester"]


    util=GeoUtilities2D.new
    #ans1=util.intersects(l,g)
    #ans2=util.intersects(l2,g)
    ans3=util.intersects(l3,g)
    
    #puts [ans1,ans2,ans3]
    #if ans1==true && ans2==true && ans3==false
      #return true
    #end
    false
  end

  def gg_intersects
    g1=readg("/Users/xiaoxiaohui/Documents/program/crystal/Crystal_GeoSpatial_Lib/CGS_Test_App/src/RedPolygon.kml")
    g2=readg("/Users/xiaoxiaohui/Documents/program/crystal/Crystal_GeoSpatial_Lib/CGS_Test_App/src/PurplePolygon.kml")

    util=GeoUtilities2D.new
    t=util.intersects(g1,g2)
    
    if t==true
      return true
    end
    false
  end

  #read Xml to get a list of points
  def readg(path)
    arr=[] of GeoPolygon
    
    res=parseKML(path)
    temp = res[2]
    case temp
    when GeoPolygon
      arr<<temp
      
    end

    return arr[0]
  end

  def readl(path)
    arr1=[] of GeoPolyline
    res1=parseKML(path)
    temp1 = res1[2]
    case temp1
    when GeoPolyline
      arr1<<temp1    
    end
    return arr1[0]
  end

  def readp(path )
    arr2=[] of GeoPoint
    res2=parseKML(path)
    temp2 = res2[2]
    case temp2
    when GeoPoint
      arr2<<temp2
      return arr2[0]
    end
    return Geopoint.new(0,0,0)
  end

  def display
  end
end

tester=Tester.new
tester.autoTest()
#l1=tester.readl("/Users/xiaoxiaohui/Documents/program/crystal/Crystal_GeoSpatial_Lib/CGS_Test_App/src/1770line.kmz")
#l1=l1.@array_of_geo.clone
#util=GeoUtilities2D.new
#d=util.distanceGC(l1[0],l1[1])
#puts ["dis", d]