class Material
  attr_accessor :colour, :ambient, :diffuse, :specular, :shininess

  def initialize(colour: Colour(1, 1, 1), ambient: 0.1, diffuse: 0.9,
                 specular: 0.9, shininess: 200)
    @colour = colour
    @ambient = ambient
    @diffuse = diffuse
    @specular = specular
    @shininess = shininess
  end

  def lighting(light, point, eye_vector, normal_vector)
    light_dot_normal = light_vector(light, point).dot(normal_vector)
    if light_dot_normal.negative?
      diffuse_colour = Colour::BLACK
      specular_colour = Colour::BLACK
    else
      diffuse_colour = effective_colour(light) * diffuse * light_dot_normal
      specular_colour =
        specular_colour_from(light, point, eye_vector, normal_vector)
    end
    colour_from ambient_colour(light) + specular_colour + diffuse_colour
  end

  private

  def colour_from(colour_tuple)
    Colour(colour_tuple.x, colour_tuple.y, colour_tuple.z)
  end

  def ambient_colour(light)
    effective_colour(light) * ambient
  end

  def effective_colour(light)
    @effective_colour ||= colour * light.intensity
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

def Material
  Material.new
end
