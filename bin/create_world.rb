require_relative '../lib/canvas'
require_relative '../lib/matrix'
require_relative '../lib/tuple'
require_relative '../lib/ray'
require_relative '../lib/material'
require_relative '../lib/sphere'
require_relative '../lib/point_light'
require_relative '../lib/intersection'
require_relative '../lib/transformation'
require_relative '../lib/world'
require_relative '../lib/camera'
require 'benchmark'

width = 400
height = 200

floor = Sphere()
floor.transform = scaling(10, 0.01, 10)
floor.material = Material().tap do |m|
  m.colour = Colour(1, 0.9, 0.9)
  m.specular = 0
end

left_wall = Sphere()
left_wall.transform =
  translation(0, 0, 5) *
  rotation_y(-Math::PI / 4) *
  rotation_x(Math::PI / 2) *
  scaling(10, 0.01, 10)
left_wall.material = Material().tap do |m|
  m.colour = Colour(1, 0.9, 0.9)
  m.specular = 0
end

right_wall = Sphere()
right_wall.transform =
  translation(0, 0, 5) *
  rotation_y(Math::PI / 4) *
  rotation_x(Math::PI / 2) *
  scaling(10, 0.01, 10)
right_wall.material = Material().tap do |m|
  m.colour = Colour(1, 0.9, 0.9)
  m.specular = 0
end

middle_sphere = Sphere()
middle_sphere.transform = translation(-0.5, 1, 0.5)
middle_sphere.material = Material().tap do |m|
  m.colour = Colour(0.1, 1, 0.5)
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
  m.colour = Colour(0, 0.1, 1)
  m.diffuse = 0.7
  m.specular = 0.3
end

light_position = Point(5, 1, -10)
#light_position = Point(-10, 10, -10)
light_colour = Colour(1, 1, 1)
light = PointLight(light_position, light_colour)

world = World(
  objects: [
    floor,
    left_wall,
    right_wall,
    middle_sphere,
    right_sphere,
    left_sphere
  ],
  light_source: light
)

camera = Camera(width, height, Math::PI / 3)
camera.transform = Matrix.view_transform(
  from: Point(0, 1.5, -5),
  to: Point(0, 1, 0),
  up: Vector(0, 1, 0)
)
image = camera.render(world)

IO.write('scene.ppm', image.to_ppm.string)
