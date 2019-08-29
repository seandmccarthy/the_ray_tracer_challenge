class World
  attr_accessor :objects, :light_source

  def initialize(objects: [], light_source: nil)
    @objects = objects
    @light_source = light_source
  end

  def intersect(ray)
    objects.map { |obj| obj.intersect(ray) }.reduce(:+)
  end

  def shade_hit(comps)
    comps.object.material.lighting(
      object: comps.object,
      light: light_source,
      point: comps.over_point,
      eye_vector: comps.eye_vector,
      normal_vector: comps.normal_vector,
      in_shadow: shadowed?(comps.over_point)
    )
  end

  def colour_at(ray)
    hit = intersect(ray).hit
    return Colour(0, 0, 0) if hit.nil?
    shade_hit(hit.prepare_computations(ray))
  end

  def shadowed?(point)
    v = light_source.position - point
    distance = v.magnitude
    direction = v.normalise
    ray = Ray(point, direction)
    hit = intersect(ray).hit
    !hit.nil? && hit.t < distance
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
