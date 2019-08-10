class Material
  attr_accessor :colour, :ambient, :diffuse, :specular, :shininess, :pattern

  def initialize(colour: Colour(0.9, 0.9, 0.9), ambient: 0.1, diffuse: 0.9,
                 specular: 0.9, shininess: 200, pattern: nil)
    @colour = colour
    @ambient = ambient
    @diffuse = diffuse
    @specular = specular
    @shininess = shininess
    @pattern = pattern
  end

  def lighting(object:, light:, point:, eye_vector:, normal_vector:, in_shadow: false)
    light_dot_normal = light_vector(light, point).dot(normal_vector)
    local_colour = pattern&.pattern_at_shape(shape: object, point: point) || colour
    effective_colour = local_colour * light.intensity
    ambient_colour = effective_colour * ambient
    return colour_from(ambient_colour) if in_shadow
    if light_dot_normal.negative?
      diffuse_colour = Colour::BLACK
      specular_colour = Colour::BLACK
    else
      diffuse_colour = effective_colour * diffuse * light_dot_normal
      specular_colour =
        specular_colour_from(light, point, eye_vector, normal_vector)
    end
    colour_from(ambient_colour + specular_colour + diffuse_colour)
  end

  private

  def colour_from(colour_tuple)
    Colour(colour_tuple.x, colour_tuple.y, colour_tuple.z)
  end

  def light_vector(light, point)
    @light_vector ||= (light.position - point).normalise
  end

  def specular_colour_from(light, point, eye_vector, normal_vector)
    reflect_vector = -light_vector(light, point).reflect(normal_vector)
    reflect_dot_eye = reflect_vector.dot(eye_vector).round(5)**shininess
    if reflect_dot_eye <= 0
      Colour::BLACK
    else
      light.intensity * specular * reflect_dot_eye
    end
  end
end

def Material(*args)
  Material.new(*args)
end
