require_relative '../lib/canvas'
require_relative '../lib/matrix'
require_relative '../lib/tuple'
require_relative '../lib/ray'
require_relative '../lib/material'
require_relative '../lib/sphere'
require_relative '../lib/point_light'
require_relative '../lib/intersection'
require_relative '../lib/transformation'

origin_z = -5
ray_origin = Point(0, 0, origin_z)
gradient = 1 / (0 - origin_z.to_f)
wall_z = 10
margin = 2
wall_size = ((wall_z - origin_z) * gradient + margin) * 2
canvas_pixels = 200
pixel_size = wall_size / canvas_pixels
half = wall_size / 2

material_colour = Colour(1, 1, 0) # Colour(1, 0.2, 1)
material = Material().tap { |m| m.colour = material_colour }
sphere = Sphere().tap { |s| s.material = material }
#sphere.transform = scaling(1, 0.5, 1)
light_position = Point(-10, 10, -10)
light_colour = Colour(1, 1, 1)
light = PointLight(light_position, light_colour)
canvas = Canvas(canvas_pixels, canvas_pixels)
colour = Colour(1, 1, 0)

(0..canvas_pixels - 1).each do |y|
  world_y = half - pixel_size * y
  (0..canvas_pixels - 1).each do |x|
    world_x = -half + pixel_size * x

    position = Point(world_x, world_y, wall_z)
    r = Ray(ray_origin, (position - ray_origin).normalise)
    xs = sphere.intersect(r)
    hit = xs.hit
    next if xs.hit.nil?
    point = r.position(hit.t)
    normal = hit.object.normal_at(point)
    eye = -r.direction
    colour = material.lighting(light, point, eye, normal)
    canvas.write_pixel(x, y, colour)
  end
end

IO.write('sphere_raycast.ppm', canvas.to_ppm.string)
