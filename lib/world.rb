class World
  attr_accessor :objects, :light_source, :depth

  DEFAULT_DEPTH = 5

  def initialize(objects: [], light_source: nil, depth: DEFAULT_DEPTH)
    @depth = depth
    @objects = objects
    @light_source = light_source
  end

  def intersect(ray)
    objects.map { |obj| obj.intersect(ray) }.reduce(:+)
  end

  def shade_hit(comps, remaining = depth)
    surface = comps.object.material.lighting(
      object: comps.object,
      light: light_source,
      point: comps.over_point,
      eye_vector: comps.eye_vector,
      normal_vector: comps.normal_vector,
      in_shadow: shadowed?(comps.over_point)
    )
    reflected = reflected_colour(comps, remaining)
    refracted = refracted_colour(comps, remaining)
    material = comps.object.material
    t = 
      if material.reflective > 0 && material.transparency > 0
        reflectance = schlick(comps)
        surface + reflected * reflectance + refracted * (1 - reflectance)
      else
        surface + reflected + refracted
      end
    Colour(t.x, t.y, t.z)
  end

  def colour_at(ray, remaining = depth)
    hit = intersect(ray).hit
    return Colour::BLACK if hit.nil?
    shade_hit(hit.prepare_computations(ray), remaining)
  end

  def shadowed?(point)
    v = light_source.position - point
    distance = v.magnitude
    direction = v.normalise
    ray = Ray(point, direction)
    hit = intersect(ray).hit
    !hit.nil? && hit.t < distance
  end

  def reflected_colour(comps, remaining = depth)
    return Colour::BLACK if comps.object.material.reflective.zero? || remaining.zero?
    reflect_ray = Ray(comps.over_point, comps.reflect_vector)
    colour = colour_at(reflect_ray, remaining - 1)
    colour * comps.object.material.reflective
  end

  def refracted_colour(comps, remaining = depth)
    if comps.object.material.transparency.zero? || remaining.zero?
      return Colour::BLACK
    end
    total_internal_reflection = comps.sin2_t > 1.0
    return Colour::BLACK if total_internal_reflection

    cos_t = Math.sqrt(1.0 - comps.sin2_t)
    direction =
      (comps.normal_vector * (comps.n_ratio * comps.cos_i - cos_t)) -
      (comps.eye_vector * comps.n_ratio)
    refracted_ray = Ray(comps.under_point, direction)
    colour_at(refracted_ray, remaining - 1) * comps.object.material.transparency
  end
end

def World(objects: [], light_source: nil, depth: World::DEFAULT_DEPTH)
  World.new(objects: objects, light_source: light_source, depth: depth)
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
