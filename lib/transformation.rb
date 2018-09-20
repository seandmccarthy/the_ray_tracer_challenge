def Translation(x, y, z)
  Matrix.identity(4).tap do |m|
    m[0, 3] = x
    m[1, 3] = y
    m[2, 3] = z
  end
end

def Scaling(x, y, z)
  Matrix.identity(4).tap do |m|
    m[0, 0] = x
    m[1, 1] = y
    m[2, 2] = z
  end
end
