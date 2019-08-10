class Camera
  attr_reader :hsize, :vsize, :field_of_view, :pixel_size
  attr_accessor :transform

  DEFAULT_WORKERS = 4

  def initialize(hsize, vsize, field_of_view, transform = Matrix.identity)
    @hsize = hsize
    @vsize = vsize
    @field_of_view = field_of_view
    @transform = transform
    calculate_sizes
  end

  def ray_for_pixel(px, py)
    x_offset = (px + 0.5) * @pixel_size
    y_offset = (py + 0.5) * @pixel_size
    world_x = @half_width - x_offset
    world_y = @half_height - y_offset
    pixel = @transform.inverse * Point(world_x, world_y, -1)

    origin = @transform.inverse * Point(0, 0, 0)
    direction = (pixel - origin).normalise
    Ray(origin, direction)
  end

  def render(world, workers: DEFAULT_WORKERS)
    chunk_size = @vsize / workers
    Canvas(@hsize, @vsize).tap do |image|
      workers.times.map do |i|
        Thread.new do
          y_start = i * chunk_size
          y_end = (i + 1) * chunk_size
          (y_start...y_end).each do |y|
            render_row_at(y, image, world)
          end
        end
      end.each(&:join)
    end
  end

  private

  def render_row_at(y, image, world)
    (0...@hsize).each do |x|
      ray = ray_for_pixel(x, y)
      colour = world.colour_at(ray)
      image.write_pixel(x, y, colour)
    end
  end

  def calculate_sizes
    half_view = Math.tan(@field_of_view / 2.0)
    aspect = hsize / vsize.to_f
    @half_width = aspect >= 1 ? half_view : half_view * aspect
    @half_height = aspect >= 1 ? half_view / aspect : half_view
    @pixel_size = @half_width * 2 / @hsize
  end
end

def Camera(*args)
  Camera.new(*args)
end
