# TODO: Write documentation for `CGSTestApp`
require "../src/geo"
require "../src/tester"

module CGSTestApp
  VERSION = "0.1.0"

  # Our algorithms are written in ../src/geo
  util=GeoUtilities2D.new
  p1=GeoPoint.new(38.9, 77.0, 1.0) # 73.1 N, 77.0 S, 1.0m 

  # run tester to see if intersections formed by our shapes can be judged properly by our functions in geo
  # we need to tell tester the right answer to tester firstly 
  test=Tester.new
  test.autoTest

end
