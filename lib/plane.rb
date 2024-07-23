class Plane < Shape
  def normal_at_shape(object_space_point)
    Vector(0, 1, 0)
  end

  def intersect_shape(object_space_ray)
    return Intersections() if object_space_ray.direction.y.abs < 0.00001
    t = -object_space_ray.origin.y / object_space_ray.direction.y
    Intersections(Intersection(t, self))
  end
end

def Plane(**args)
  Plane.new(**args)
end
