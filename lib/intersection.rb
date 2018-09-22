require 'ostruct'
class Intersection
  attr_reader :t, :object
  
  def initialize(t, object)
    @t = t
    @object = object
  end
end

def Intersection(t, object)
  Intersection.new(t, object)
end

def Intersections(*args)
  Array(args)
end
