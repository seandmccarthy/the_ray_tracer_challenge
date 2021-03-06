def translation(x, y, z)
  Matrix.identity(4).tap do |m|
    m[0, 3] = x
    m[1, 3] = y
    m[2, 3] = z
  end
end

def scaling(x, y, z)
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

def shearing(xy, xz, yx, yz, zx, zy)
  Matrix(
    [1, xy, xz, 0],
    [yx, 1, yz, 0],
    [zx, zy, 1, 0],
    [0, 0, 0, 1]
  )
end

def view_transform(from:, to:, up:)
  forward = (to - from).normalise
  up_normal = up.normalise
  left = forward.cross(up_normal)
  true_up = left.cross(forward)
  orientation = Matrix(
    [left.x,     left.y,     left.z,     0],
    [true_up.x,  true_up.y,  true_up.z,  0],
    [-forward.x, -forward.y, -forward.z, 0],
    [0,          0,          0,          1]
  )
  orientation * translation(-from.x, -from.y, -from.z)
end
