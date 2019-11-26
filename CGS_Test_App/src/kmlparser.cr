require "xml"
require "file"
require "io"
require "../src/geo"

def parseKML(filename : String)

	xmlstring = File.read(filename)
	xmldoc = XML.parse(xmlstring)
	
	root = xmldoc.first_element_child
  shape_name = ""
  isPolygon = false
  isLine = false
  isPoint = false
  coordinate_string = ""
  lon_string = ""
  lat_string = ""
  alt_string = ""
	
	if root
		root.children.select(&.element?).each do |child|
			if child.name == "Document"
        document = child
        document.children.select(&.element?).each do |child|
          if child.name == "Placemark"
            placemark = child
            placemark.children.select(&.element?).each do |child|
              if child.name == "name"
                shape_name = child.content
              end
              if child.name == "Polygon"
                polygon = child
                isPolygon = true
                polygon.children.select(&.element?).each do |child|
                  if child.name == "outerBoundaryIs"
                    outer = child
                    outer.children.select(&.element?).each do |child|
                      if child.name == "LinearRing"
                        ring = child
                        ring.children.select(&.element?).each do |child|
                          if child.name == "coordinates"
                            coordinate_string = child.content
                          end 
                        end
                      end          
                    end
                  end
                end
              end 
              if child.name == "LineString" 
                line = child
                isLine = true
                line.children.select(&.element?).each do |child|
                  if child.name == "coordinates"
                    coordinate_string = child.content
                  end
                end
              end
              if child.name == "Point"
                point = child
                isPoint = true
                point.children.select(&.element?).each do |child|
                  if child.name == "coordinates"
                    coordinate_string = child.content
                  end
                end 
              end
            end
          end
        end
      end
		end
      
	end
  
  if isPolygon
    arr1 = coordinate_string.split()
    pointList = [] of GeoPoint
    arr1.each do |string|
      arr = string.split(",", remove_empty: true)
      point = GeoPoint.new(arr[1].to_f,arr[0].to_f,arr[2].to_f)
      pointList << point
    end
    polygon = GeoPolygon.new(pointList)
    return {"polygon", shape_name, polygon,}
    
  elsif isLine
    arr1 = coordinate_string.split()
    pointList = [] of GeoPoint
    arr1.each do |string|
      arr = string.split(",", remove_empty: true)
      point = GeoPoint.new(arr[1].to_f,arr[0].to_f,arr[2].to_f)
      pointList << point
    end
    polyline = GeoPolyline.new(pointList)
    return {"polyline", shape_name, polyline}
    
  elsif isPoint
      arr = coordinate_string.split(",", remove_empty: true)
      point = GeoPoint.new(arr[1].to_f,arr[0].to_f,arr[2].to_f)
    return {"point", shape_name, point}
    
  else
    return {"nil", shape_name, nil}
  end
 
end









