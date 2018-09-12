def Canvas(width, height)
  Canvas.new(width, height)
end

class Canvas
  attr_reader :width, :height, :pixels
  PPM_LINE_SIZE = 70

  def initialize(width, height)
    @width = width
    @height = height
    @pixels = Array.new(@width * @height, Colour(0, 0, 0))
  end

  def write_pixel(x, y, colour)
    pixels[x + width * y] = colour
  end

  def pixel_at(x, y)
    pixels[x + width * y]
  end

  def to_ppm
    ppm = StringIO.new
    write_ppm_header(ppm)
    height.times do |y|
      row = []
      width.times do |x|
        row.concat map_colour(pixel_at(x, y))
      end
      write_ppm_row(ppm, row)
    end
    ppm.tap(&:rewind)
  end

  private

  def write_ppm_header(ppm)
    ppm.puts <<~HEADER
      P3
      #{width} #{height}
      255
    HEADER
  end

  def write_ppm_row(ppm, row)
    row.join(' ').scan(/.{1,#{PPM_LINE_SIZE}}(?:\b)/).each do |line|
      ppm.puts(line.strip)
    end
  end

  def map_colour(colour)
    [pixel_clamp(colour.red), pixel_clamp(colour.green), pixel_clamp(colour.blue)]
  end

  def pixel_clamp(raw_value)
    x = (raw_value * 255).round(0)
    [0, [x, 255].min].max
  end
end
