# TODO: Write documentation for `CGSTestApp`
require "../src/geo"
require "../src/tester"
require "../src/kmlparser"


def polygonMenu(names)
  
  puts "choose a polygon"
  val = 1
  names.each do |name|
    puts val.to_s + " - " + name
    val +=1
  end

  input = gets.not_nil!.chomp.to_i

  return input
end

def polylineMenu(names)
  
  puts "choose a polyline"
  val = 1
  names.each do |name|
    puts val.to_s + " - " + name
    val +=1
  end

  input = gets.not_nil!.chomp.to_i

  return input
end

def pointMenu(names)
  
  puts "choose a point"
  val = 1
  names.each do |name|
    puts val.to_s + " - " + name
    val +=1
  end

  input = gets.not_nil!.chomp.to_i

  return input
end


module CGSTestApp
  VERSION = "0.1.0"

  

  
  polygons = [] of GeoPolygon
  polygonNames = [] of String
  polylines = [] of GeoPolyline
  polylineNames = [] of String
  points = [] of GeoPoint
  pointNames = [] of String

  val = parseKML("GreenPolygon.kml")
  val2 = val[2]
  case val2
    when GeoPolygon
    polygons << val2
    polygonNames << val[1]
  end
    
  val = parseKML("PurplePolygon.kml")
  val2 = val[2]
  case val2
    when GeoPolygon
    polygons << val2
    polygonNames << val[1]
  end
    
  val = parseKML("RedPolygon.kml")
  val2 = val[2]
  case val2
    when GeoPolygon
    polygons << val2
    polygonNames << val[1]
  end
    
  val = parseKML("GoldPolyline.kml")
  val2 = val[2]
  case val2
    when GeoPolyline
    polylines << val2
    polylineNames << val[1]
  end
    
  val = parseKML("BluePoint.kml")
  val2 = val[2]
  case val2
    when GeoPoint
    points << val2
    pointNames << val[1]
  end
    
  util=GeoUtilities2D.new
    
  
  mainmenu = "Choose a function\n"
  mainmenu += "1 - polygon x polygon intersection\n"
  mainmenu += "2 - polygon x polyline intersection\n"
  mainmenu += "3 - polyline x polyline intersection\n"
  mainmenu += "4 - polygon contains point\n"
  mainmenu += "5 - polyline contains point\n"
  mainmenu += "6 - euclidean distance\n"
  mainmenu += "7 - great circle distance\n"
  while(true)
    puts mainmenu
    
    input = gets.not_nil!.chomp.to_i
    
    case input
      when 1
      choise1 = polygonMenu(polygonNames)-1
      if choise1 >= polygonNames.size
        puts "\nINVALID CHOISE\n"
        next
      end
      choise2 = polygonMenu(polygonNames)-1
      if choise2 >= polygonNames.size
        puts "\nINVALID CHOISE\n"
        next
      end
      puts util.intersects(polygons[choise1],polygons[choise2])

      when 2
      choise1 = polygonMenu(polygonNames)-1
      if choise1 >= polygonNames.size
        puts "\nINVALID CHOISE\n"
        next
      end
      choise2 = polylineMenu(polylineNames)-1
      if choise2 >= polylineNames.size
        puts "\nINVALID CHOISE\n"
        next
      end
      puts util.intersects(polylines[choise2],polygons[choise1])
      
      when 3
      choise1 = polylineMenu(polylineNames)-1
      if choise1 >= polylineNames.size
        puts "\nINVALID CHOISE\n"
        next
      end
      choise2 = polylineMenu(polylineNames)-1
      if choise2 >= polylineNames.size
        puts "\nINVALID CHOISE\n"
        next
      end
      #puts util.intersects(polylines[choise2],polylines[choise1])
      
      when 4
      choise1 = polygonMenu(polygonNames)-1
      if choise1 >= polygonNames.size
        puts "\nINVALID CHOISE\n"
        next
      end
      choise2 = pointMenu(pointNames)-1
      if choise2 >= pointNames.size
        puts "\nINVALID CHOISE\n"
        next
      end
      puts util.intersects(points[choise2],polygons[choise1])
      
      when 5
      choise1 = polylineMenu(polylineNames)-1
      if choise1 >= polylineNames.size
        puts "\nINVALID CHOISE\n"
        next
      end
      choise2 = pointMenu(pointNames)-1
      if choise2 >= pointNames.size
        puts "\nINVALID CHOISE\n"
        next
      end
      puts util.intersects(points[choise2],polylines[choise1])
      
      when 6
      choise1 = pointMenu(pointNames)-1
      if choise1 >= pointNames.size
        puts "\nINVALID CHOISE\n"
        next
      end
      choise2 = pointMenu(pointNames)-1
      if choise2 >= pointNames.size
        puts "\nINVALID CHOISE\n"
        next
      end
      
      puts util.distanceEuclidean(points[choise2],points[choise1])
      
      when 7
      choise1 = pointMenu(pointNames)-1
      if choise1 >= pointNames.size
        puts "\nINVALID CHOISE\n"
        next
      end
      choise2 = pointMenu(pointNames)-1
      if choise2 >= pointNames.size
        puts "\nINVALID CHOISE\n"
        next
      end
      
      puts util.distanceGC(points[choise2],points[choise1])
    end
    
    #puts polygonMenu(polygonNames)
    #puts polylineMenu(polylineNames)
    #puts pointMenu(pointNames)
  end
  
  
  
  
  

end
