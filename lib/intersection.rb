class Intersection
  attr_reader :t, :object, :point, :eye_vector, :normal_vector, :inside

  OFFSET = 0.000001

  def initialize(t, object)
    @t = t
    @object = object
  end

  def prepare_computations(ray)
    point = ray.position(@t)
    normal_vector = @object.normal_at(point)
    eye_vector = -ray.direction
    inside = false
    if normal_vector.dot(eye_vector).negative?
      inside = true
      normal_vector = -normal_vector
    end
    OpenStruct.new(
      t: @t,
      object: @object,
      point: point,
      eye_vector: eye_vector,
      normal_vector: normal_vector,
      inside: inside,
      reflect_vector: ray.direction.reflect(normal_vector),
      over_point: point + normal_vector * 0.0001
    )
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
