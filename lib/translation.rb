def Translation(x, y, z)
  Matrix.identity(4).tap do |m|
    m[0, 3] = x
    m[1, 3] = y
    m[2, 3] = z
  end
end
