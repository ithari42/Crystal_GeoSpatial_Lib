PI = 3.14159265358979323846

class GeoPoint
	def initialize(lat : Float64, lon : Float64, alt : Float64)
			@lat=lat
			@lon=lon
			@alt=alt
			@array_of_geo=[@lat,@lon,@alt]
	end

	def lat
		@lat
	end

	def lon
		@lon
	end
  
  def alt
    @alt
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

	###
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
			#ca=get_ca(p1,p2)
			#dis=ca*@R_Earth
      
      puts "" + p1.lon.to_s + "," + p1.lat.to_s
      puts "" + p2.lon.to_s + "," + p2.lat.to_s
      
      x1 = (p1.alt + @R_Earth/2) * Math.cos(p1.lat * PI/180) * Math.sin(p1.lon * PI/190)
      y1 = (p1.alt + @R_Earth/2) * Math.sin(p1.lat * PI/190)
      z1 = (p1.alt + @R_Earth/2) * Math.cos(p1.lat * PI/180) * Math.cos(p1.lon * PI/190)
      
      x2 = (p2.alt + @R_Earth/2) * Math.cos(p2.lat * PI/180) * Math.sin(p2.lon * PI/190)
      y2 = (p2.alt + @R_Earth/2) * Math.sin(p2.lat * PI/190)
      z2 = (p2.alt + @R_Earth/2) * Math.cos(p2.lat * PI/180) * Math.cos(p2.lon * PI/190)
      
      dis = ((x2-x1)**2 + (y2-y1)**2 + (z2-z1)**2)**(1/2)
      
      
			return dis
		end

		def distanceGC(p1 : GeoPoint, p2 : GeoPoint)
			#dis=get_ca(p1,p2)/360
			#dis*=@R_Earth
      
      puts "" + p1.lon.to_s + "," + p1.lat.to_s
      puts "" + p2.lon.to_s + "," + p2.lat.to_s
      
      lon1 = p1.lon * (PI/180) 
      lon2 = p2.lon * (PI/180)
      lat1 = p1.lat * (PI/180)
      lat2 = p2.lat * (PI/180)
			dlon = (lon2 - lon1)
			dlat = (lat2 - lat1)
      a = Math.sin(dlat/2)**2 + Math.cos(lat1) * Math.cos(lat2) * Math.sin(dlon/2)**2
      c = 2 * Math.atan2(a**(1/2), (1-a)**(1/2))
      dis = c * @R_Earth

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

	def intersects(l1 : GeoPolyline, l2 : GeoPolyline)
		line1=l1.@array_of_geo.clone
		line2=l2.@array_of_geo.clone
		n1=line1.size
		n2=line2.size
		i=0
		j=0
		while i<n1-1	
			while j<n2-1
				s1=get_subline(line1, i)
				s2=get_subline(line2, j)
				if intersects(s1,s2)
					return true
				end
				j+=1
			end
			i+=1
			j=0
		end
		return false
	end

	def intersects(subline1, subline2)
		pi=3.14159265358979323846

		ap1=subline1[0]
		ap2=subline1[1]
		ap3=subline2[0]
		ap4=subline2[1]


		p1=GeoPoint.new(ap1[0],ap1[1], 1)
		q1=GeoPoint.new(ap2[0], ap2[1], 1)
		p2=GeoPoint.new(ap3[0], ap3[1], 1)
		q2=GeoPoint.new(ap4[0], ap4[1], 1)

		b1=bearing_angle(p1, q1)
		b2=bearing_angle(p2, q2)

		#puts ["b", b1, b2]
		#l1=subline_to_GeoPolyline(subline1)
		#l2=subline_to_GeoPolyline(subline2)
		phi, lam=two_line_intersection(p1, b1, p2, b2)
		p3=GeoPoint.new(phi, lam, 1)

		#puts [phi, lam]
		
		angle1=get_ca(p1, q1)
		angle2=get_ca(p1, p3)

		#puts ["angle",angle1, angle2]
		if(angle1>=angle2)
			return true
		end
		return false
	end

	def intersects(l : GeoPolyline, g : GeoPolygon)
		ldata=l.@array_of_geo.clone
		gdata=g.@array_of_geo.clone
		puts ["ldata",ldata]
		gdata<<gdata[0]
		puts ["gdata",gdata]
		n1=ldata.size
		n2=gdata.size
		i=0
		j=0
		while i<n1-1
			sl=get_subline(ldata,i)
			while j<n2-1
				gl=get_subline(gdata, j)
				if intersects(sl, gl)
					puts ["sl",sl,"gl",gl,"i",i,"j",j]
					return true
				end
				j+=1
			end
			i+=1
			j=0
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
		#inverse
		d=g2.@array_of_geo.clone
		n=d.size
		x=0
		while x<n 
			if intersects(d[x],g1)
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

	def subline_to_GeoPolyline(subline)		
		l=GeoPolyline.new(subline_to_GeoPoint(subline))
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
		dphi_sin_2=GeoUtilities2D.sin(dphi/2)

		dlam_sin_2=Math.sin(dlam/2)

		
		ca=Math.sin(dphi/2)*Math.sin(dphi/2)

		ca+=Math.cos(phi1)*Math.cos(phi2)*dlam_sin_2*dlam_sin_2
		
		ca=2*GeoUtilities2D.atan2(GeoUtilities2D.sqrt(ca),GeoUtilities2D.sqrt(1-ca)) 
		
		ca=GeoUtilities2D.asin(ca)*180/pi

		ca=ca%360
		ca=Math.sqrt(ca)
		
		ca=Math.asin(ca)*180/pi
		
		ca*=2

		return ca

	end

	#return bearing from p1 to p2
	def bearing_angle(p1 : GeoPoint, p2 : GeoPoint)
		pi=3.14159265358979323846
		pd1=p1.@array_of_geo.clone
		pd2=p2.@array_of_geo.clone

		lam1=pd1[1]*pi/180
		lam2=pd2[1]*pi/180
		phi1=pd1[0]*pi/180
		phi2=pd2[0]*pi/180
		dlam=lam2-lam1

		theta1=GeoUtilities2D.sin(dlam)*GeoUtilities2D.cos(phi2)
		theta2=GeoUtilities2D.cos(phi1)*GeoUtilities2D.sin(phi2)
		theta2=theta2-GeoUtilities2D.sin(phi1)*GeoUtilities2D.cos(phi2)*GeoUtilities2D.cos(dlam)

		
		ans=GeoUtilities2D.atan2(theta1,theta2)
		ans=ans*180/pi
	end

	#return intersection point given two path
	#b1 b2 are in degree
	def two_line_intersection(p1 : GeoPoint, b1, p2 : GeoPoint, b2)
		pi=3.14159265358979323846

		theta13=b1*pi/180
		theta23=b2*pi/180

		pd1=p1.@array_of_geo.clone
		pd2=p2.@array_of_geo.clone
		lam1=pd1[1]*pi/180
		lam2=pd2[1]*pi/180
		phi1=pd1[0]*pi/180
		phi2=pd2[0]*pi/180
		dlam=lam1-lam2
		dphi=phi1-phi2

		delta12=GeoUtilities2D.sin(dphi/2)*GeoUtilities2D.sin(dphi/2)
		delta12=delta12+GeoUtilities2D.cos(phi1)*GeoUtilities2D.cos(phi2)*GeoUtilities2D.sin(dlam/2)*GeoUtilities2D.sin(dlam/2)
		delta12=2*GeoUtilities2D.atan2(GeoUtilities2D.sqrt(delta12), GeoUtilities2D.sqrt(1-delta12))

		theta1=GeoUtilities2D.sin(phi2)-GeoUtilities2D.sin(phi1)*GeoUtilities2D.cos(delta12)
		theta1=theta1/GeoUtilities2D.sin(delta12)/GeoUtilities2D.cos(phi1)
		theta1=GeoUtilities2D.acos(theta1)

		theta2=GeoUtilities2D.sin(phi1)-GeoUtilities2D.sin(phi2)*GeoUtilities2D.cos(delta12)
		theta2=theta2/GeoUtilities2D.sin(delta12)/GeoUtilities2D.cos(phi2)
		theta2=GeoUtilities2D.acos(theta2)

		if GeoUtilities2D.sin(-dlam) > 0
			theta12 = theta1
			theta21 = 2*pi-theta2
		else
			theta12 = 2*pi-theta1
			theta21 = theta2
		end

		alpha1=theta13-theta12
		alpha2=theta21-theta23

		#puts ["alpha213",alpha1*180/pi,"alpha123",alpha2*180/pi]
		alpha3=-1.0*GeoUtilities2D.cos(alpha1)*GeoUtilities2D.cos(alpha2)+GeoUtilities2D.sin(alpha1)*GeoUtilities2D.sin(alpha2)*GeoUtilities2D.cos(delta12)
		alpha3=GeoUtilities2D.acos(alpha3)

		delta13a=GeoUtilities2D.sin(delta12)*GeoUtilities2D.sin(alpha1)*GeoUtilities2D.sin(alpha2)
		delta13b=GeoUtilities2D.cos(alpha2)+GeoUtilities2D.cos(alpha1)*GeoUtilities2D.cos(alpha3)
		delta13=GeoUtilities2D.atan2(delta13a,delta13b)

		phi3=GeoUtilities2D.sin(phi1)*GeoUtilities2D.cos(delta13)
		phi3+=GeoUtilities2D.cos(phi1)*GeoUtilities2D.sin(delta13)*GeoUtilities2D.cos(theta13)
		#puts ["phi3",phi3]
		phi3=GeoUtilities2D.asin(phi3)

		dlam13a=GeoUtilities2D.sin(theta13)*GeoUtilities2D.sin(delta13)*GeoUtilities2D.cos(phi1)
		dlam13b=GeoUtilities2D.cos(delta13)-GeoUtilities2D.sin(phi1)*GeoUtilities2D.sin(phi3)
		dlam13=GeoUtilities2D.atan2(dlam13a,dlam13b)

		lam3=lam1+dlam13

		phi3=phi3*180/pi
		lam3=lam3*180/pi
		
		return [phi3,lam3]
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

	#return if a Geopoint is on the left of a subline in GreatCircle manner
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

	def same_line_side(p : GeoPoint, sl : GeoPolyline, flag)
		x=0
		line=sl.@array_of_geo.clone
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

util=GeoUtilities2D.new
p1=GeoPoint.new(39.1, 94.6, 1.0) # 73.1 N, 77.0 S, 1.0m 
p2=GeoPoint.new(29, 57.0, 1.0)
p3=GeoPoint.new(29, 120.0, 1.0)
p4=GeoPoint.new(18.6, 94.6, 1.0)

l1=GeoPolyline.new([p1,p4])
l2=GeoPolyline.new([p2,p3])

b1=util.bearing_angle(p1,p4)
b2=util.bearing_angle(p2,p3)

#puts ["b",b1,b2]
	
#k=util.intersects(l1,l2)
#puts ["k", k]

