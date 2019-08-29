class Shape
  attr_accessor :transform, :material

  def initialize(material: Material.new, transform: Matrix.identity(4))
    @material = material
    @transform = transform
  end

  def intersect(ray)
    intersect_shape(to_object_space(ray))
  end

  def normal_at(world_point)
    object_point = transform.inverse * world_point
    object_normal = normal_at_shape(object_point)
    world_normal = transform.inverse.transpose * object_normal
    world_normal.w = 0
    world_normal.normalise
  end

  def intersect_shape(*)
    raise NotImplementedError
  end

  def normal_at_shape(*)
    raise NotImplementedError
  end

  private

  def to_object_space(ray)
    ray.transform(@transform.inverse)
  end
end
