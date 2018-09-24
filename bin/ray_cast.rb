require_relative '../lib/canvas'
require_relative '../lib/matrix'
require_relative '../lib/tuple'
require_relative '../lib/ray'
require_relative '../lib/sphere'
require_relative '../lib/intersection'
require_relative '../lib/transformation'

origin_z = -10
ray_origin = Point(0, 0, origin_z)
gradient = 1 / (0 - origin_z.to_f)
wall_z = 10
margin = 5
wall_size = ((wall_z - origin_z) * gradient + margin) * 2
canvas_pixels = 200
pixel_size = wall_size / canvas_pixels
half = wall_size / 2

sphere = Sphere()
canvas = Canvas(canvas_pixels, canvas_pixels)
colour = Colour(1, 1, 0)

(0..canvas_pixels - 1).each do |y|
  world_y = half - pixel_size * y
  (0..canvas_pixels - 1).each do |x|
    world_x = -half + pixel_size * x

    position = Point(world_x, world_y, wall_z)
    r = Ray(ray_origin, (position - ray_origin).normalise)
    xs = sphere.intersect(r)

    canvas.write_pixel(x, y, colour) unless xs.hit.nil?
  end
end

IO.write('sphere_raycast.ppm', canvas.to_ppm.string)
