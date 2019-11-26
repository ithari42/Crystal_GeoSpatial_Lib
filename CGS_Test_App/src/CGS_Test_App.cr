# TODO: Write documentation for `CGSTestApp`
require "../src/geo"
require "../src/tester"
require "../src/kmlparser"

ClrScrn = "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"

def polygonMenu(names)
  
  puts ClrScrn
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
  
  puts ClrScrn
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
  
  puts ClrScrn
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
  
  val = parseKML("BlackPolyline.kml")
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
  
  val = parseKML("RedPoint.kml")
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
  
  puts ClrScrn
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
      result = util.intersects(polygons[choise1],polygons[choise2])

      puts ClrScrn
      outstring = polygonNames[choise1]
      if result
        outstring += " intersects "
      else
        outstring += " does not intersect "
      end
      
      outstring += polygonNames[choise2] + "\n\n"
      puts outstring
      
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
      result =  util.intersects(polylines[choise2],polygons[choise1])
      
      puts ClrScrn
      outstring = polygonNames[choise1]
      if result
        outstring += " intersects "
      else
        outstring += " does not intersect "
      end
      
      outstring += polylineNames[choise2] + "\n\n"
      puts outstring
      
      
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
      #result = util.intersects(polylines[choise2],polylines[choise1])
      result = true
      puts ClrScrn
      outstring = polylineNames[choise1]
      if result
        outstring += " intersects "
      else
        outstring += " does not intersect "
      end
      
      outstring += polylineNames[choise2] + "\n\n"
      puts outstring
      
      
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
      result =  util.intersects(points[choise2],polygons[choise1])
      
      puts ClrScrn
      outstring = polygonNames[choise1]
      if result
        outstring += " contains "
      else
        outstring += " does not contain "
      end
      
      outstring += pointNames[choise2] + "\n\n"
      puts outstring
      
      
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
      result =  util.intersects(points[choise2],polylines[choise1])
      
      puts ClrScrn
      outstring = polylineNames[choise1]
      if result
        outstring += " contains "
      else
        outstring += " does not contain "
      end
      
      outstring += pointNames[choise2] + "\n\n"
      puts outstring
      
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
      
      result = util.distanceEuclidean(points[choise2],points[choise1])
      
      puts ClrScrn
      outstring = pointNames[choise1] + " is " + result.to_s + "km from " + pointNames[choise2] + "\n\n"
      puts outstring
      
      
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
      
      result = util.distanceGC(points[choise2],points[choise1])
      
      puts ClrScrn
      outstring = pointNames[choise1] + " is " + result.to_s + "km from " + pointNames[choise2] + "\n\n"
      puts outstring
    end
    
    #puts polygonMenu(polygonNames)
    #puts polylineMenu(polylineNames)
    #puts pointMenu(pointNames)
  end
  
  
  
  
  

end
