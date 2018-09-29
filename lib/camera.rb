class Camera
  attr_reader :hsize, :vsize, :field_of_view, :pixel_size
  attr_accessor :transform

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

  private

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
