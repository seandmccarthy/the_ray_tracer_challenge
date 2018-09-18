require_relative '../lib/tuple'
require_relative '../lib/canvas'
require 'ostruct'
require 'logger'

SCALE = 10
CANVAS_WIDTH = 20 * SCALE
CANVAS_HEIGHT = 20 * SCALE
logger = Logger.new(STDOUT)

def projectile(position, velocity)
  OpenStruct.new position: position, velocity: velocity
end

proj = projectile(Point(0, 1, 0), Vector(1, 1, 0).normalise)
world = OpenStruct.new gravity: Vector(0, -0.05, 0), wind: Vector(-0.01, 0, 0)
canvas = Canvas(CANVAS_WIDTH, CANVAS_HEIGHT)

def tick(world, proj)
  position = proj.position + proj.velocity
  velocity = proj.velocity + world.gravity + world.wind
  projectile(position, velocity)
end

def plot(position:, canvas:, colour: Colour(0, 1, 0), scale: SCALE)
  x = (position.x * scale).round(0)
  y = canvas.height - (position.y * scale).round(0)
  canvas.write_pixel(x, y, colour)
end

logger.debug proj.position.inspect
loop do
  plot(position: proj.position, canvas: canvas)
  proj = tick(world, proj)
  logger.debug proj.position.inspect
  break if proj.position.y <= 0
end

IO.write("plot_#{Time.now.to_i}.ppm", canvas.to_ppm.string)
