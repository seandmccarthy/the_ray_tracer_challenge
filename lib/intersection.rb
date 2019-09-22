require 'ostruct'
require 'forwardable'

class Intersection
  attr_reader :t, :object, :point, :eye_vector, :normal_vector, :inside

  OFFSET = 0.0001

  def initialize(t, object)
    @t = t
    @object = object
  end

  def prepare_computations(ray, xs = nil)
    xs ||= Intersections(self)
    point = ray.position(@t)
    normal_vector = @object.normal_at(point)
    eye_vector = -ray.direction
    inside = false
    if normal_vector.dot(eye_vector).negative?
      inside = true
      normal_vector = -normal_vector
    end
    n1, n2 = compute_ns(xs)
    n_ratio = n1 / n2
    cos_i = eye_vector.dot(normal_vector)
    OpenStruct.new(
      t: @t,
      object: @object,
      point: point,
      eye_vector: eye_vector,
      normal_vector: normal_vector,
      inside: inside,
      reflect_vector: ray.direction.reflect(normal_vector),
      over_point: point + normal_vector * OFFSET,
      under_point: point - normal_vector * OFFSET,
      n1: n1,
      n2: n2,
      n_ratio: n1 / n2,
      cos_i: cos_i,
      sin2_t: n_ratio**2 * (1 - cos_i**2)
    )
  end

  private

  def compute_ns(xs)
    containers = []
    n1 = 1.0
    n2 = 1.0
    xs.each do |i|
      if i == self
        n1 = n_value(containers)
      end

      if containers.delete(i.object).nil?
        containers << i.object
      end

      if i == self
        n2 = n_value(containers)
        break
      end
    end
    [n1, n2]
  end

  def n_value(containers)
    return 1.0 if containers.empty?
    containers.last.material.refractive_index
  end
end

def Intersection(t, object)
  Intersection.new(t, object)
end

class Intersections
  extend Forwardable
  attr_reader :intersections
  def_delegators :@intersections, :each, :each_with_index, :[], :empty?

  def initialize(*args)
    @intersections = Array(args).sort_by(&:t)
  end

  def count
    @intersections.count
  end

  def +(other)
    Intersections(*(@intersections + other.intersections))
  end

  def hit
    @hit ||= @intersections.find { |i| i.t.positive? }
  end
end

def Intersections(*args)
  Intersections.new(*args)
end

def schlick(comps)
  cos = comps.cos_i
  if comps.n1 > comps.n2
    return 1.0 if comps.sin2_t > 1.0
    cos = Math.sqrt(1.0 - comps.sin2_t)
  end
  r0 = ((comps.n1 - comps.n2) / (comps.n1 + comps.n2))**2
  (r0 + (1 - r0) * (1 - cos)**5).round(Tuple::DECIMAL_PLACES)
end
