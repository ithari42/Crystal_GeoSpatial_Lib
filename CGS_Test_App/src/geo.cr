class GeoPoint
  def initialize(lat : Float64, lon : Float64, alt : Float64)
		@lat=lat
		@lon=lon
		@alt=alt
  end

  def coordinate2d
		
		{@lat,@lon}
    
  end

  def coordinate3d
    {@lat,@lon,@alt}
  end
end

class GeoPolyline
	def initialize(points)#Need a tuple of GeoPoint
		@array_of_geo =[] of GeoPoint
		@array_of_geo= points
		
	end

	def toPolygon #return a polygon formed by connecting head and rear Geopoint
		return GeoPolygon.new(@points)
	end
  
	def allNorth # returns true if all of the points are in the northeren hemisphere, false otherwise
				x=0
				flag=true
				while x < @array_of_geo.size && flag ==true
				if @array_of_geo[x].@lat < 0 || @array_of_geo[x].@lon < 0 || @array_of_geo[x].@alt <0        
					puts "some of your your points are south "
					flag=false
				end
	            x=x+1
				end
	if flag == true
	puts "your points are north"
	end

	
      		
	end
	
	def allSouth # returns true if all of the points are in the southern hemisphere, false otherwise
				x=0
				flag=true
				while x < @array_of_geo.size && flag==true
				if @array_of_geo[x].@lat > 0 || @array_of_geo[x].@lon > 0 || @array_of_geo[x].@alt >0        
					puts "some of your points are north "
					flag=false
				end
	            x=x+1
				end
	if flag == true
	puts "your points are south"
	end

	end
	
end
class GeoPolygon
	def initialize(@points)
	end

	def contains
	end

	def toPolyline
		return GeoLine.new(@points)
	end

	def isConvex
	end
	
	def allNorth # returns true if all of the points are in the northeren hemisphere, false otherwise
	end

	def allSouth # returns true if all of the points are in the southern hemisphere, false otherwise
	end
end
class GeoUtilities2D
  def distanceEuclidean(p1 : GeoPoint, p2 : Geopoint)
    dis=-1.0
    return dis
  end

  def distanceGC(p1 : GeoPoint, p2 : Geopoint)
    dis=-1.0
    return dis
  end

  def intersects(p : GeoPoint, l : GeoPolyline)
    
  end

  def intersects(p : GeoPoint, g : GeoPolygon)
    
  end

  def intersects(l : GeoPolyline, g : GeoPolygon)
    
  end

  def intersects(g1 : GeoPolygon, g2 : GeoPolygon)
    
  end
end

k=GeoPoint.new(3,3,3)
v=GeoPoint.new(1,2,4)
array_of_geo = [] of GeoPoint
array_of_geo << k
array_of_geo << v
z=GeoPolyline.new(array_of_geo)
z.allNorth
z.allSouth
# z.array_of_geo[1].@lat

