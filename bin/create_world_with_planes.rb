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
require_relative '../lib/pattern'
require_relative '../lib/gradient_pattern'
require_relative '../lib/ring_pattern'
require_relative '../lib/stripe_pattern'
require_relative '../lib/checker_pattern'
require_relative '../lib/blended_pattern'
require 'benchmark'

multiplier = 4
width = 200 * multiplier
height = 100 * multiplier

def pick_colour
  rand(0.4...1.0).round(1)
end

vertical = StripePattern(a: Colour(0.9, 0.9, 0.9), b: Colour(0.2, 0.5, 0.2))
horizontal = StripePattern(a: Colour(0.9, 0.9, 0.9), b: Colour(0.2, 0.5, 0.2), transform: rotation_y(Math::PI / 2))
blended = BlendedPattern(a: horizontal, b: vertical)
ring = RingPattern(a: Colour(0.8, 0.8, 0.8), b: Colour(0.8, 0.3, 0.3), transform: scaling(0.2, 0.2, 0.2) * translation(-25, -5, -5))
checker = CheckerPattern(a: Colour(0.6, 0.6, 0.2), b: Colour(0.7, 0.7, 0.2))

floor = Plane()
floor.transform = translation(0, 0, 0)
floor.material = Material(pattern: blended, specular: 0)

back_wall = Plane()
back_wall.transform =
  translation(0, 0, 3) *
  rotation_x(Math::PI / 2)
back_wall.material = Material(colour: Colour(0.7, 0.7, 0.7), specular: 0)

left_wall = Plane()
left_wall.transform =
  translation(0, 0, 5) *
  rotation_y(-Math::PI / 4) *
  rotation_x(Math::PI / 2)
left_wall.material = Material.new(pattern: ring)

right_wall = Plane()
right_wall.transform =
  translation(0, 0, 5) *
  rotation_y(Math::PI / 4) *
  rotation_x(Math::PI / 2)
right_wall.material = Material(specular: 0, pattern: checker)

left_side = Plane()
left_side.transform =
  translation(-4, 0, 0) *
  rotation_y(-Math::PI / 2) *
  rotation_x(Math::PI / 2)
left_side.material = Material(specular: 0)

right_side = Plane()
right_side.transform =
  translation(4, 0, 0) *
  rotation_y(Math::PI / 2) *
  rotation_x(Math::PI / 2)
right_side.material = Material(specular: 0)

middle_sphere = Sphere()
middle_sphere.transform = translation(-0.5, 1, 0.5)
middle_sphere.material = Material().tap do |m|
  r, g, b = pick_colour, pick_colour, pick_colour
  m.pattern = StripePattern(
    a: Colour(r, g, b), b: Colour(1.0 - r, 1.0 - g, 1.0 - b),
    transform: scaling(0.25, 0.25, 0.25) * rotation_z(-Math::PI / 4)
  )
  m.colour = Colour(r, g, b)
  m.diffuse = 0.7
  m.specular = 0.3
end

right_sphere = Sphere()
right_sphere.transform = translation(1.5, 1, -0.5) * scaling(0.5, 0.5, 0.5)
right_sphere.material = Material().tap do |m|
  m.colour = Colour(1, 0, 0.1)
  m.pattern = GradientPattern(a: Colour::WHITE, b: Colour::GREEN, transform: scaling(2.0, 1.0, 1.0) * translation(-0.5, 0, 0))
  m.diffuse = 0.7
  m.specular = 0.3
end

left_sphere = Sphere()
left_sphere.transform = translation(-1.5, 0.33, -0.75) * scaling(0.33, 0.33, 0.33)
left_sphere.material = Material(
  colour: Colour(0.3, 0.3, 0.7),
  diffuse: 0.9,
  specular: 0.9
)

hover_sphere = Sphere()
hover_sphere.transform = translation(-0.2, 1.5, -0.85) * scaling(0.25, 0.25, 0.25)
hover_sphere.material = Material(
  colour: Colour(0.8, 0.8, 0.1),
  diffuse: 0.7,
  specular: 0.3
)

hover_sphere2 = Sphere()
hover_sphere2.transform = translation(1.7, 1.75, 0.65) * scaling(0.5, 0.5, 0.5)
hover_sphere2.material = Material().tap do |m|
  m.colour = Colour(0.1, 0.8, 0.8)
  m.pattern = CheckerPattern(
    a: m.colour, b: Colour::WHITE,
    transform: scaling(0.5, 0.5, 0.5) * rotation_x(Math::PI / 4)
  )
  m.diffuse = 0.7
  m.specular = 0.3
end

eclipsed_sphere = Sphere()
eclipsed_sphere.transform =
  translation(0.85, 0.25, 1.5) * scaling(0.25, 0.25, 0.25)
eclipsed_sphere.material = Material(
  colour: Colour(0.9, 0.9, 0.9),
  diffuse: 0.9,
  specular: 0.3
)

light_position = Point(-3, 5, -10)
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
  from: Point(0, 2.5, -5),
  to: Point(0, 1, 0),
  up: Vector(0, 1, 0)
)

workers = ARGV[0] || 4
Benchmark.bm(10) do |x|
  image = nil
  filename = "scene_#{Time.now.strftime('%FT%T')}.ppm"
  x.report('render:') { image = camera.render(world, workers: workers.to_i) }
  x.report('to_ppm:') { IO.write(filename, image.to_ppm.string) }
end
