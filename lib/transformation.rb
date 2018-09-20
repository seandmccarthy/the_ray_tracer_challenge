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

def rotation_x(rad)
  Matrix(
    [1, 0, 0, 0],
    [0, Math.cos(rad), -Math.sin(rad), 0],
    [0, Math.sin(rad), Math.cos(rad), 0],
    [0, 0, 0, 1]
  )
end

def rotation_y(rad)
  Matrix(
    [Math.cos(rad), 0, Math.sin(rad), 0],
    [0, 1, 0, 0],
    [-Math.sin(rad), 0, Math.cos(rad), 0],
    [0, 0, 0, 1]
  )
end

def rotation_z(rad)
  Matrix(
    [Math.cos(rad), -Math.sin(rad), 0, 0],
    [Math.sin(rad), Math.cos(rad), 0, 0],
    [0, 0, 1, 0],
    [0, 0, 0, 1]
  )
end
