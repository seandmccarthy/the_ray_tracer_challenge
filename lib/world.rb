class World
  attr_accessor :objects, :light_source

  def initialize(objects: [], light_source: nil)
    @objects = objects
    @light_source = light_source
  end

  def intersect(ray)
    objects.map { |obj| obj.intersect(ray) }.reduce(:+)
  end

  def shade_hit(hit)
    hit.object.material.lighting(
      light_source, hit.point, hit.eye_vector, hit.normal_vector
    )
  end

  def colour_at(ray)
    hit = intersect(ray).hit
    return Colour(0, 0, 0) if hit.nil?
    hit.prepare_hit(ray)
    shade_hit(hit)
  end
end

def World(objects: [], light_source: nil)
  World.new(objects: objects, light_source: light_source)
end

def default_world
  light = PointLight(Point(-10, 10, -10), Colour(1, 1, 1))
  material = Material.new(colour: Colour(0.8, 1.0, 0.6), diffuse: 0.7, specular: 0.2)
  World(
    objects:
      [
        Sphere.new(material: material),
        Sphere.new(transform: scaling(0.5, 0.5, 0.5))
      ],
    light_source: light
  )
end
