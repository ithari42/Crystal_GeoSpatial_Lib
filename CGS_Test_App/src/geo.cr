class GeoPoint
  def initialize(lat : Float64, lon : Float64, alt : Float64)
		@lat=lat
		@lon=lon
		@alt=alt
  end

  def lat
	@lat
  end

  def lon
	@lon
  end

  def coordinate2d
		[@lat,@lon]
  end

  def coordinate3d
    [@lat,@lon,@alt]
  end
end

class GeoPolyline
	def initialize(points)#Need a tuple of GeoPoint
		@array_of_geo =[] of GeoPoint
		@array_of_geo= points
		
	end

	def data
		@array_of_geo
	end

	def toPolygon #return a polygon formed by connecting head and rear Geopoint
		return GeoPolygon.new(@points)
	end
  
	def allNorth # returns true if all of the points are in the northeren hemisphere, false otherwise
		x=0
		flag=true
		while x < @array_of_geo.size && flag ==true
			if @array_of_geo[x].@lat < 0        
					#puts "some of your your points are south "
					flag=false
			end
	        x=x+1
		end	
		return x	
	end
	
	def allSouth # returns true if all of the points are in the southern hemisphere, false otherwise
		x=0
		flag=true
		while x < @array_of_geo.size && flag==true
			if @array_of_geo[x].@lat         
				puts "some of your points are north "
				flag=false
			end
	        x=x+1
		end
		return x
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
	flag=false
	line=l.data
	x=0
	n=line.size
	while x<n-1 
		subline=get_subline(l,x,x+1)
		#if on_subline(p,subline) ...
		x+=1
	end
  end

  def intersects(p : GeoPoint, g : GeoPolygon)
    
  end

  def intersects(l : GeoPolyline, g : GeoPolygon)
    
  end

  def intersects(g1 : GeoPolygon, g2 : GeoPolygon)
    
  end
#utile functions

#Input: subline must be [[float64, float64],[float64, float64]]
  def v_dotProduct(v1,v2)
	if v1.size>2||v2.size>2
		"dot product error"
	end
	return (v1[0]*v2[1]-v1[2]*v2[1])
  end
#return [[lat1,lon1],[lat2,lon2]]
#ith subline (i,i+1), i starts with 0
#i must be i<size-1
  def get_subline(l : GeoPolyline, i : Int32)
	if i>=l.size||j>=l.size
		"get_subline out of range"
	end
	d=l.data
	return [[d[i].lat,d[i].lon],[d[i+1].lat,d[i+1].lon]]
  end

  def on_subline(p : Geopoint, s)
	
  end

  def enum_polygon(l : GeoPolyline) # return a tuple containing each vector on a polygon
	
  end
end

"geo.cr test"
p1=GeoPoint.new(38.9, 77.0, 1.0) # 73.1 N, 77.0 S, 1.0m 
p2=GeoPoint.new(38.9, 78.0, 1.0)
l1=GeoPolyline.new([p1,p2])
