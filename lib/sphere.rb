class Sphere
  def intersect(ray)
    sphere_to_ray = ray.origin - Point(0, 0, 0)
    a = ray.direction.dot(ray.direction)
    b = 2 * ray.direction.dot(sphere_to_ray)
    c = sphere_to_ray.dot(sphere_to_ray) - 1
    discriminant = b * b - 4 * a * c
    return [] if discriminant < 0
    t1 = (-b - Math.sqrt(discriminant)) / (2 * a)
    t2 = (-b + Math.sqrt(discriminant)) / (2 * a)
    [t1, t2].sort
  end
end

def Sphere
  Sphere.new
end
