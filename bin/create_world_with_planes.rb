require_relative '../lib/canvas'
require_relative '../lib/matrix'
require_relative '../lib/tuple'
require_relative '../lib/ray'
require_relative '../lib/material'
require_relative '../lib/shape'
require_relative '../lib/plane'
require_relative '../lib/sphere'
require_relative '../lib/point_light'
require_relative '../lib/intersection'
require_relative '../lib/transformation'
require_relative '../lib/world'
require_relative '../lib/camera'
require_relative '../lib/stripe_pattern'
require 'benchmark'

multiplier = 1
width = 200 * multiplier
height = 100 * multiplier

def pick_colour
  rand(0.4...1.0).round(1)
end

floor = Plane()
floor.transform = translation(0, 0, 0)
floor.material = Material().tap do |m|
  m.pattern = StripePattern(a: Colour(0.6, 0.6, 0.8), b: Colour(0.7, 0.7, 0.9))
  m.colour = Colour(1, 0.9, 0.9)
  m.specular = 0
end

back_wall = Plane()
back_wall.transform =
  translation(0, 0, 3) *
  rotation_x(Math::PI / 2)
back_wall.material = Material().tap do |m|
  m.colour = Colour(1, 0.9, 0.9)
  m.specular = 0
end

left_wall = Plane()
left_wall.transform =
  translation(0, 0, 5) *
  rotation_y(-Math::PI / 4) *
  rotation_x(Math::PI / 2)
left_wall.material = Material().tap do |m|
  m.colour = Colour(1, 0.9, 0.9)
  m.specular = 0
end

right_wall = Plane()
right_wall.transform =
  translation(0, 0, 5) *
  rotation_y(Math::PI / 4) *
  rotation_x(Math::PI / 2)
right_wall.material = Material().tap do |m|
  m.colour = Colour(1, 0.9, 0.9)
  m.specular = 0
end

left_side = Plane()
left_side.transform =
  translation(-4, 0, 0) *
  rotation_y(-Math::PI / 2) *
  rotation_x(Math::PI / 2)
left_side.material = Material().tap do |m|
  m.colour = Colour(1, 0.9, 0.9)
  m.specular = 0
end

right_side = Plane()
right_side.transform =
  translation(4, 0, 0) *
  rotation_y(Math::PI / 2) *
  rotation_x(Math::PI / 2)
right_side.material = Material().tap do |m|
  m.colour = Colour(1, 0.9, 0.9)
  m.specular = 0
end


middle_sphere = Sphere()
middle_sphere.transform = translation(-0.5, 1, 0.5)
middle_sphere.material = Material().tap do |m|
  #r = pick_colour; g = pick_colour; b = pick_colour
  r = 0.9; g = 0.4; b = 0.8
  #puts "#{r}, #{g}, #{b}"
  #m.colour = Colour(0.1, 1, 0.5)
  m.pattern = StripePattern(a: Colour(r, g, b), b: Colour(0.8, 0.8, 0.8)).tap do |p|
    p.transform = scaling(0.25, 0.25, 0.25) * rotation_y(-Math::PI / 4)
  end
  m.colour = Colour(r, g, b)
  m.diffuse = 0.7
  m.specular = 0.3
end

right_sphere = Sphere()
right_sphere.transform = translation(1.5, 0.5, -0.5) * scaling(0.5, 0.5, 0.5)
right_sphere.material = Material().tap do |m|
  m.colour = Colour(1, 0, 0.1)
  m.diffuse = 0.7
  m.specular = 0.3
end

left_sphere = Sphere()
left_sphere.transform =
  translation(-1.5, 0.33, -0.75) * scaling(0.33, 0.33, 0.33)
left_sphere.material = Material().tap do |m|
  m.colour = Colour(0.3, 0.3, 0.7)
  m.diffuse = 0.9
  m.specular = 0.9
end

hover_sphere = Sphere()
hover_sphere.transform =
  translation(-0.2, 1.5, -0.85) * scaling(0.25, 0.25, 0.25)
hover_sphere.material = Material().tap do |m|
  m.colour = Colour(0.8, 0.8, 0.1)
  m.diffuse = 0.7
  m.specular = 0.3
end

hover_sphere2 = Sphere()
hover_sphere2.transform =
  translation(1.7, 1.75, 0.65) * scaling(0.25, 0.25, 0.25)
hover_sphere2.material = Material().tap do |m|
  m.colour = Colour(0.1, 0.8, 0.8)
  m.diffuse = 0.7
  m.specular = 0.3
end

eclipsed_sphere = Sphere()
eclipsed_sphere.transform =
  translation(0.85, 0.25, 1.5) * scaling(0.25, 0.25, 0.25)
eclipsed_sphere.material = Material().tap do |m|
  m.colour = Colour(0.9, 0.9, 0.9)
  m.diffuse = 0.9
  m.specular = 0.3
end

light_position = Point(-3, 7, -10)
light_colour = Colour(1, 1, 1)
light = PointLight(light_position, light_colour)

world = World(
  objects: [
    floor,
    back_wall,
    left_wall,
    right_wall,
    left_side,
    right_side,
    middle_sphere,
    right_sphere,
    left_sphere,
    hover_sphere,
    hover_sphere2,
    eclipsed_sphere
  ],
  light_source: light
)

camera = Camera(width, height, Math::PI / 3)
camera.transform = Matrix.view_transform(
  #from: Point(0, 1.5, -5),
  from: Point(0, 4.5, -3),
  #to: Point(0, 1, 0),
  to: Point(0, 1, 0),
  up: Vector(0, 1, 0)
)
image = camera.render(world)

IO.write('scene_with_plane.ppm', image.to_ppm.string)
