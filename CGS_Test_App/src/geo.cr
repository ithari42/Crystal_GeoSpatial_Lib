class GeoPoint
  def initialize(@lat : Float64, @lon : Float64, @alt : Float64)
  end

  def coordinate2d
    {@lat,@lon}
  end

  def coordinate3d
    {@lat,@lon,@alt}
  end
end
class GeoPolyline
	def initialize(@points)#Need a tuple of GeoPoint
	end

	def toPolygon #return a polygon formed by connecting head and rear Geopoint
		return GeoPolygon.new(@points)
	end
  
	def allNorth # returns true if all of the points are in the northeren hemisphere, false otherwise
	end
	
	def allSouth # returns true if all of the points are in the southern hemisphere, false otherwise
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