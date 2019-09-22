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
require_relative '../lib/blended_pattern'
require 'benchmark'

multiplier = 2
width = 200 * multiplier
height = 100 * multiplier

DEPTH = 15
WALL_DIST = 5
MIRROR_COLOUR = 0.1
REFLECTIVE = 0.9

vertical = StripePattern(a: Colour(0.9, 0.9, 0.9), b: Colour(0.2, 0.2, 0.5))
horizontal = StripePattern(a: Colour(0.9, 0.9, 0.9), b: Colour(0.2, 0.2, 0.5), transform: rotation_y(Math::PI / 2))
blended = BlendedPattern(a: horizontal, b: vertical)
stripe = StripePattern(a: Colour(0.9, 0.9, 0.9), b: Colour(0.7, 0.7, 0.7))

floor = Plane()
floor.transform = translation(0, 0, 0)
floor.material = Material(pattern: blended, specular: 0.1, reflective: 0.3)

roof = Plane()
roof.transform = translation(0, 5, 0)
roof.material = Material(pattern: stripe, specular: 0, colour: Colour(0.8, 0.8, 0.8))

back_wall = Plane()
back_wall.transform =
  translation(0, 0, WALL_DIST + 2) *
  rotation_x(Math::PI / 2)
back_wall.material = Material(specular: 0, colour: Colour(MIRROR_COLOUR, MIRROR_COLOUR, MIRROR_COLOUR), reflective: REFLECTIVE)

camera_wall = Plane()
camera_wall.transform =
  translation(0, 0, -(WALL_DIST + 2)) *
  rotation_x(Math::PI / 2)
camera_wall.material = Material(specular: 0, colour: Colour(MIRROR_COLOUR, MIRROR_COLOUR, MIRROR_COLOUR), reflective: REFLECTIVE)

left_wall = Plane()
left_wall.transform =
  translation(WALL_DIST - 1, 0, 0) *
  rotation_y(-Math::PI / 2) *
  rotation_x(Math::PI / 2)
left_wall.material = Material(specular: 0, colour: Colour(0.2, 0.2, 0.5), reflective: 0.1)

right_wall = Plane()
right_wall.transform =
  translation(-(WALL_DIST - 1), 0, 0) *
  rotation_y(Math::PI / 2) *
  rotation_x(Math::PI / 2)
right_wall.material = Material(specular: 0, colour: Colour(0.2, 0.2, 0.5), reflective: 0.1)

middle_sphere = Sphere()
middle_sphere.transform = translation(0, 1, 1)
middle_sphere.material = Material(
  transparency: 1.0,
  refractive_index: 2.5,
  reflective: 0.5,
  diffuse: 0.3,
  ambient: 0.3,
  specular: 1.0,
  colour: Colour(0.2, 0.2, 0.2)
)

little_sphere = Sphere()
little_sphere.transform = translation(1.75, 0.5, 4.25) * scaling(0.5, 0.5, 0.5)
little_sphere.material = Material(
  reflective: 0.2,
  diffuse: 0.3,
  ambient: 0.3,
  specular: 1.0,
  colour: Colour(0.0, 0.9, 0.6)
)

light_position = Point(1, 3, -(WALL_DIST - 0.10))
light_colour = Colour(1, 1, 1)
light = PointLight(light_position, light_colour)

world = World(
  objects: [
    floor,
    roof,
    back_wall,
    camera_wall,
    left_wall,
    right_wall,
    middle_sphere,
    little_sphere
  ],
  light_source: light,
  depth: DEPTH
)

camera = Camera(width, height, Math::PI / 3)
camera.transform = view_transform(
  from: Point(-1.0, 3.0, -(WALL_DIST + 2 - 0.1)),
  to: Point(0, 1.5, 0),
  up: Vector(0, 1, 0)
)

workers = ARGV[0] || 4
Benchmark.bm(10) do |x|
  image = nil
  filename = "scene_#{Time.now.strftime('%FT%T')}.ppm"
  x.report('render:') { image = camera.render(world, workers: workers.to_i) }
  x.report('to_ppm:') { IO.write(filename, image.to_ppm.string) }
end
