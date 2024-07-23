class Sphere < Shape
  def intersect_shape(object_space_ray)
    a, b, c = coefficents(object_space_ray)
    build_intersections quadratic_roots(a, b, c)
  end

  def normal_at_shape(object_space_point)
    object_space_point - origin
  end

  private

  def origin
    @origin ||= Point(0, 0, 0)
  end

  def coefficents(ray)
    sphere_to_ray = ray.origin - origin
    a = ray.direction.dot(ray.direction)
    b = 2 * ray.direction.dot(sphere_to_ray)
    c = sphere_to_ray.dot(sphere_to_ray) - 1
    [a, b, c]
  end

  def quadratic_roots(a, b, c)
    discriminant = b * b - 4 * a * c
    return [] if discriminant < 0
    [
      (-b - Math.sqrt(discriminant)) / (2 * a),
      (-b + Math.sqrt(discriminant)) / (2 * a)
    ]
  end

  def build_intersections(t_values)
    Intersections(*t_values.sort.map { |t| Intersection(t, self) })
  end
end

def Sphere(**args)
  Sphere.new(**args)
end

def glass_sphere
  Sphere(transform: Matrix.identity, material: Material(transparency: 1.0, refractive_index: 1.5))
end
