class Intersection
  attr_reader :t, :object, :point, :eye_vector, :normal_vector, :inside

  OFFSET = 0.000001

  def initialize(t, object)
    @t = t
    @object = object
  end

  def prepare_hit(ray)
    @point = ray.position(@t)
    @eye_vector = -ray.direction
    @normal_vector = @object.normal_at(@point)
    @inside = @normal_vector.dot(@eye_vector).negative?
    @normal_vector = -@normal_vector if @inside
    @point += @normal_vector * OFFSET
  end
end

def Intersection(t, object)
  Intersection.new(t, object)
end

class Intersections
  attr_reader :intersections

  def initialize(*args)
    @intersections = Array(args).sort_by(&:t)
  end

  def count
    @intersections.count
  end

  def +(other)
    Intersections(*(@intersections + other.intersections).sort_by(&:t))
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
