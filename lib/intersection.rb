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

class Intersections
  def initialize(*args)
    @intersections = Array(args)
  end

  def count
    @intersections.count
  end

  def [](index)
    @intersections[index]
  end

  def hit
    @intersections.sort_by(&:t).find do |i|
      i.t.positive?
    end
  end
end

def Intersections(*args)
  Intersections.new(*args)
end
