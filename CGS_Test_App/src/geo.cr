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
	def_clone
	end

	class GeoPolyline
		def initialize(points)#Need a tuple of GeoPoint
			@array_of_geo =[] of GeoPoint
			@array_of_geo= points
			
		end


		def toPolygon #return a polygon formed by connecting head and rear GeoPoint
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
		def_clone
	end

	class GeoPolygon
		def initialize(points)
			@array_of_geo= [] of GeoPoint
			@array_of_geo=points
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

		def_clone
	end

	class GeoUtilities2D
		#sin, cos in Math use rads
		extend Math

		def initialize
			@R_Earth=6371.0 #currently use km as measure unit in our system. if our alg is precise enough after test, we can use meter
		end

		def distanceEuclidean(p1 : GeoPoint, p2 : GeoPoint)
			ca=get_ca(p1,p2)
			dis=ca*@R_Earth
			return dis
		end

		def distanceGC(p1 : GeoPoint, p2 : GeoPoint)
			dis=get_ca(p1,p2)/360
			dis*=@R_Earth
			return dis
		end

	def intersects(p : GeoPoint, l : GeoPolyline)
		flag=false
		line=l.@array_of_geo.clone
		x=0
		n=line.size
		while x<n-1 
			subline=get_subline(l,x)
			s=subline_to_GeoPoint(subline)

			fp1=[s[0].@lat, s[0].@lon]
			fp2=[s[1].@lat, s[1].@lon]
			fp1=GeoPoint.new(fp1[0], fp1[1], 1.0)
			fp2=GeoPoint.new(fp2[0], fp2[1], 1.0)
			if on_subline(p, fp1 , fp2)
				return true
			end
			x+=1
		end
		false
	end

	def intersects(p : GeoPoint, graph : GeoPolygon)
		flag=false
		line=graph.@array_of_geo.clone

		line<<line[0]
		subline=get_subline(line,0)
		flag=on_left_gc(p, subline)

		#puts ["flag",flag]
		if line.size<4 #the polygon doesn't even have 3 nodes
			return false
		end

		x=1
		n=line.size
		
		while x<n-1 
			subline=get_subline(line,x)
			#puts ["subline", subline]
			s=subline_to_GeoPoint(subline)

			fp1=[s[0].@lat, s[0].@lon]
			fp2=[s[1].@lat, s[1].@lon]
			fp1=GeoPoint.new(fp1[0], fp1[1], 1.0)
			fp2=GeoPoint.new(fp2[0], fp2[1], 1.0)
			if on_left_gc(p, subline)!=flag
				return false
			end
			x+=1
		end
		true
	end

	def intersects(l : GeoPolyline, g : GeoPolygon)
		d=l.@array_of_geo.clone
		n=d.size
		x=0
		while x<n 
			if intersects(d[x],g)
				return true
			end
			x+=1
		end
		return false
	end

	def intersects(g1 : GeoPolygon, g2 : GeoPolygon)
		d=g1.@array_of_geo.clone
		n=d.size
		x=0
		while x<n 
			if intersects(d[x],g2)
				return true
			end
			x+=1
		end
		return false
	end

	
	#utile functions
	
#Math related
	def v_dotProduct2d(v1,v2)
		if v1.size>2||v2.size>2
			"dot product error"
		end
		return (v1[0]*v2[1]-v1[2]*v2[1])
	end

	def v_dotProduct3d(v1,v2)
		if v1.size>2||v2.size>2
			"dot product error"
		end
		return (v1[0]*v2[0]+v1[1]*v2[1]+v1[2]*v2[2])
	end

	def xyz_crossProduct(v1,v2)
		a=v1[0]
		b=v1[1]
		c=v1[2]

		d=v2[0]
		e=v2[1]
		f=v2[2]

		return [b*f-c*e, c*d-a*f, a*e-d*b]
	end

	def in_a_line3d(p1, p2, p3)
		#to do judge here
		false
	end

#GIS coordinate related
	#return [[lat1,lon1],[lat2,lon2]]
	#ith subline (i,i+1), i starts with 0
	#i must be i<size-1
	def get_subline(l : GeoPolyline, i )
		#if i>=l.size||j>=l.size
		#	"get_subline out of range"
		#end
		d=l.@array_of_geo.clone
		return [[d[i].lat,d[i].lon],[d[i+1].lat,d[i+1].lon]]
	end

	def get_subline(line , i )
		d1=[line[i].@lat, line[i].@lon]
		d2=[line[i+1].@lat, line[i+1].@lon]
		return [[d1[0],d1[1]],[d2[0],d2[1]]]
	end

	def subline_to_GeoPoint(subline)
		v0=subline[0]
		v1=subline[1]
		p1=GeoPoint.new(v0[0], v0[1], 1.0)
		p2=GeoPoint.new(v1[0], v1[1], 1.0)
		[p1,p2]
	end
	#return central angle in degree
	def get_ca(p1 : GeoPoint, p2 : GeoPoint)
		pi=3.14159265358979323846
		p1_2d=[p1.@lat, p1.@lon]
		p2_2d=[p2.@lat, p2.@lon]

		phi1=p1_2d[0]*pi/180
		lam1=p1_2d[1]*pi/180
		phi2=p2_2d[0]*pi/180
		lam2=p2_2d[1]*pi/180

		dphi=phi1-phi2
		dlam=lam1-lam2
		
		dlam_sin_2=GeoUtilities2D.sin(dlam/2)
		
		ca=GeoUtilities2D.sin(dphi/2)*GeoUtilities2D.sin(dphi/2)

		ca+=GeoUtilities2D.cos(phi1)*GeoUtilities2D.cos(phi2)*dlam_sin_2*dlam_sin_2
		
		ca=GeoUtilities2D.sqrt(ca)
		
		ca=GeoUtilities2D.asin(ca)*180/pi
		
		ca*=2

		return ca

	end

	#return if r on great circle p, q, in the sense of 0.00001 earth radius
	#p q must not construct a rear position
	def on_subline(r : GeoPoint, p : GeoPoint, q : GeoPoint)
		if in_a_line3d(r, p, q)
			puts "error determining the great circle in on_subline()"
		end
		
		rr=@R_Earth
		d=dist_p_CenterSurface(r,p,q)
		if d<0
			d=-d
		end

		if d < rr*0.00001
			true
		else
			false
		end

	end

	def enum_polygon(l : GeoPolyline) # return a tuple containing each vector on a polygon
		
	end

#coordinate transfer related
	#return transferred latitude longtitude coordinate, in degree
	def ll_to_tll(p : GeoPoint)
		t=[p.@lat, p.@lon, p.@alt]
		lat=t[0]
		lon=t[1]
		if 	lon >0
			lon=360-lon
		else
			lon=-lon
		end

		pn=GeoPoint.new(lat,lon,t[2])
		return pn
	end

	def ll_to_tll(subline)
		lat=subline[0]
		lon=subline[1]
		if 	lon >0
			lon=360-lon
		else
			lon=-lon
		end

		return [lat,lon]
	end

	def ll_to_xyz(p : GeoPoint)
		p=ll_to_tll(p)

		dd=[p.@lat, p.@lon]
		phi=dd[0]
		lam=dd[1]
		r=@R_Earth
		x=r*GeoUtilities2D.sin(phi)*GeoUtilities2D.cos(lam)
		y=r*eoUtilities2D.sin(phi)*GeoUtilities2D.sin(lam)
		z=r*GeoUtilities2D.cos(phi)

		return [x,y,z]
	end

	def ll_to_xyz(subline)
		subline=ll_to_tll(subline)

		pi=3.14159265358979323846
		phi=subline[0]*pi/180
		lam=subline[1]*pi/180
		r=@R_Earth
		x=r*GeoUtilities2D.sin(phi)*GeoUtilities2D.cos(lam)
		y=r*GeoUtilities2D.sin(phi)*GeoUtilities2D.sin(lam)
		z=r*GeoUtilities2D.cos(phi)

		return [x,y,z]
	end

	#return if a geopoint is on the left of a subline in GreatCircle manner
	#subline [[lat1,lon1],[lat2,lon2]]
	def on_left_gc(r : GeoPoint, subline)
		p=subline[0]
		q=subline[1]
		r=[r.@lat, r.@lon]

		p=ll_to_xyz(p)
		q=ll_to_xyz(q)
		r=ll_to_xyz(r)

		#puts ["p q r",p,q,r]
		c=[0,0,0]
		vecn=xyz_NormalVector(p ,q, c)
		
		pr=xyz_vector(p,r)

		vecn=xyz_vec_std(vecn)
		pr=xyz_vec_std(pr)
		#puts ["vecn",vecn,pr]
		if v_dotProduct3d(vecn,pr)>0
			true 
		else
			false
		end
	end

	#return distance from surface<p1,p2,[0,0,0]> to r
	def dist_p_CenterSurface(r : GeoPoint, p1 : GeoPoint, p2 : GeoPoint)
		p1=[p1.@lat, p1.@lon]
		p2=[p2.@lat, p2.@lon]
		

		p1=ll_to_xyz(p1)
		p2=ll_to_xyz(p2)
		p3=[0, 0, 0]

		vn=xyz_NormalVector(p1,p2,p3)
		vn=xyz_vec_std(vn)

		r=[r.@lat, r.@lon]
		r=ll_to_xyz(r)

		vr=xyz_vector(r,p1)
		v_dotProduct3d(vr,vn)
		#puts ["vecn",vecn,"vr", vr]
	end

	#make a vector from two sublines, p3 to p1
	def xyz_vector(p1,p3)
		v1=[
			p1[0]-p3[0],
			p1[1]-p3[1],
			p1[2]-p3[2]
		]
	end

	#vecn=[x,y,z], return vector size = 1
	def xyz_vec_std(vecn)
		m_vecn=vecn[0]*vecn[0]+vecn[1]*vecn[1]+vecn[1]*vecn[1]
		m_vecn=GeoUtilities2D.sqrt(m_vecn)
		return [vecn[0]/m_vecn,vecn[1]/m_vecn,vecn[2]/m_vecn]
	end

	#p=[x,y,z]
	def xyz_NormalVector(p1,p2,p3)
		v1=[
			p1[0]-p3[0],
			p1[1]-p3[1],
			p1[2]-p3[2]
		]
		v2=[
			p2[0]-p3[0],
			p2[1]-p3[1],
			p2[2]-p3[2]
		]
		return xyz_crossProduct(v1,v2)
	end
	end


	p1=GeoPoint.new(38.9, 77.0, 1.0) # 73.1 N, 77.0 S, 1.0m 
	p2=GeoPoint.new(58.9, 77.0, 1.0)
	l1=GeoPolyline.new([p1,p2])


	p3=GeoPoint.new(30,74,1.0)
	util=GeoUtilities2D.new
	sl=util.get_subline(l1,0)
	#puts util.on_left_gc(p3,sl)
