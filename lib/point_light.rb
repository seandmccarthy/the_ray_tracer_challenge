PointLight = Struct.new(:position, :intensity)

def PointLight(position, intensity)
  PointLight.new(position, intensity)
end
