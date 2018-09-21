require_relative '../lib/canvas'
require_relative '../lib/matrix'
require_relative '../lib/tuple'
require_relative '../lib/transformation'

canvas = Canvas(300, 300)
centre_x = 300 / 2
centre_y = 300 / 2
clock_radius = 120
white = Colour(1, 1, 1)

centre_point = Point(centre_x, centre_y, 0)
canvas.write_pixel(centre_point.x, centre_point.y, white)

point = Point(0, 1, 0)
translate = translation(centre_x, centre_y, 0)
scale = scaling(clock_radius, clock_radius, 0)
(0..11).each do |i|
  rotate = rotation_z(i * Math::PI / 6.0)
  p = translate * rotate * scale * point
  canvas.write_pixel(p.x.round(0), p.y.round(0), white)
end
IO.write('clock.ppm', canvas.to_ppm.string)
