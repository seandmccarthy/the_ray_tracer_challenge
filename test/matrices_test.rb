require 'minitest/autorun'
require_relative '../lib/matrix'
require_relative '../lib/tuple'

class TestMatrices < Minitest::Test
  def test_creating_a_matrix
    m = Matrix(
      [1, 2, 3, 4],
      [5.5, 6.5, 7.5, 8.5],
      [9, 10, 11, 12],
      [13.5, 14.5, 15.5, 16.5]
    )
    assert_equal m[0, 0], 1
    assert_equal m[1, 0], 5.5
    assert_equal m[1, 2], 7.5
    assert_equal m[2, 2], 11
    assert_equal m[3, 0], 13.5
    assert_equal m[3, 2], 15.5
  end

  def test_creating_2x2
    m = Matrix(
      [-3, 5],
      [1, -2]
    )
    assert_equal m.row_size, 2
    assert_equal m.column_size, 2
  end

  def test_creating_3x3
    m = Matrix(
      [-3, 5, 0],
      [1, -2, -7],
      [0, 1, 1]
    )
    assert_equal m.row_size, 3
    assert_equal m.column_size, 3
  end

  def test_rows
    m = Matrix([1, 2], [3, 4])
    assert_equal m.rows, [[1, 2], [3, 4]]
  end

  def test_columns
    m = Matrix([1, 2], [3, 4])
    assert_equal m.columns, [[1, 3], [2, 4]]
  end

  def test_equals
    m1 = Matrix([1, 2], [3, 4])
    m2 = Matrix([1, 2], [3, 4])
    assert_equal m1, m2
  end

  def test_multiplication
    a = Matrix(
      [1, 2, 3, 4],
      [2, 3, 4, 5],
      [3, 4, 5, 6],
      [4, 5, 6, 7]
    )
    b = Matrix(
      [0, 1, 2, 4],
      [1, 2, 4, 8],
      [2, 4, 8, 16],
      [4, 8, 16, 32]
    )
    assert_equal a * b, Matrix(
      [24, 49, 98, 196],
      [31, 64, 128, 256],
      [38, 79, 158, 316],
      [45, 94, 188, 376]
    )
  end

  def test_multiply_by_tuple
    m = Matrix(
      [1, 2, 3, 4],
      [2, 4, 4, 2],
      [8, 6, 4, 1],
      [0, 0, 0, 1]
    )
    t = Tuple(1, 2, 3, 1)
    assert_equal m * t, Tuple(18, 24, 33, 1)
  end

  def test_create_identity_matrix
    identity = Matrix.identity(3)
    assert_equal identity, Matrix(
      [1, 0, 0],
      [0, 1, 0],
      [0, 0, 1]
    )
  end

  def test_transpose
    m = Matrix(
      [0, 6, 3, 0],
      [9, 8, 0, 8],
      [1, 8, 5, 3],
      [0, 0, 5, 8]
    )
    assert_equal m.transpose, Matrix(
      [0, 9, 1, 0],
      [6, 8, 8, 0],
      [3, 0, 5, 5],
      [0, 8, 3, 8]
    )
  end

  def test_transposing_identity_is_identity
    assert_equal Matrix.identity(2).transpose, Matrix.identity(2)
  end

  def test_determinant_of_2x2
    m = Matrix(
      [1, 5],
      [-3, 2]
    )
    assert_equal m.determinant, 17
  end

  def test_submatrix_of_3x3
    m = Matrix(
      [1, 5, 0],
      [-3, 2, 7],
      [0, 6, -3]
    )
    assert_equal m.submatrix(0, 2), Matrix(
      [-3, 2],
      [0, 6]
    )
  end

  def test_submatrix_of_4x4
    m = Matrix(
      [-6, 1, 1, 6],
      [-8, 5, 8, 6],
      [-1, 0, 8, 2],
      [-7, 1, -1, 1]
    )
    assert_equal m.submatrix(2, 1), Matrix(
      [-6, 1, 6],
      [-8, 8, 6],
      [-7, -1, 1]
    )
  end

  def test_minor_of_3x3
    a = Matrix(
      [3, 5, 0],
      [2, -1, -7],
      [6, -1, 5]
    )
    b = a.submatrix(1, 0)
    assert_equal b.determinant, 25
    assert_equal a.minor(1, 0), 25
  end

  def test_cofactor_3x3
    a = Matrix(
      [3, 5, 0],
      [2, -1, -7],
      [6, -1, 5]
    )
    assert_equal a.minor(0, 0), -12
    assert_equal a.cofactor(0, 0), -12
    assert_equal a.minor(1, 0), 25
    assert_equal a.cofactor(1, 0), -25
  end

  def test_determinant_of_3x3
    a = Matrix(
      [1, 2, 6],
      [-5, 8, -4],
      [2, 6, 4]
    )
    assert_equal a.cofactor(0, 0), 56
    assert_equal a.cofactor(0, 1), 12
    assert_equal a.cofactor(0, 2), -46
    assert_equal a.determinant, -196
  end

  def test_determinant_of_4x4
    a = Matrix(
      [-2, -8, 3, 5],
      [-3, 1, 7, 3],
      [1, 2, -9, 6],
      [-6, 7, 7, -9]
    )
    assert_equal a.cofactor(0, 0), 690
    assert_equal a.cofactor(0, 1), 447
    assert_equal a.cofactor(0, 2), 210
    assert_equal a.cofactor(0, 3), 51
    assert_equal a.determinant, -4071
  end

  def test_invertible
    a = Matrix(
      [6, 4, 4, 4],
      [5, 5, 7, 6],
      [4, -9, 3, -7],
      [9, 1, 7, -6]
    )
    assert_equal a.determinant, -2120
    assert a.invertible?
  end

  def test_not_invertible
    a = Matrix(
      [-4, 2, -2, -3],
      [9, 6, 2, 6],
      [0, -5, 1, -5],
      [0, 0, 0, 0]
    )
    assert_equal a.determinant, 0
    assert !a.invertible?
  end

  def test_inverse_matrix
    a = Matrix(
      [-5, 2, 6, -8],
      [1, -5, 1,  8],
      [7, 7, -6, -7],
      [1, -3, 7, 4]
    )
    b = a.inverse
    assert_equal a.determinant, 532
    assert_equal a.cofactor(2, 3), -160
    assert_equal b[3, 2], (-160 / 532.to_f).round(5)
    assert_equal a.cofactor(3, 2), 105
    assert_equal b[2, 3], (105 / 532.to_f).round(5)
    assert_equal b, Matrix(
      [0.21805,  0.45113,  0.24060, -0.04511],
      [-0.80827, -1.45677, -0.44361,  0.52068],
      [-0.07895, -0.22368, -0.05263,  0.19737],
      [-0.52256, -0.81391, -0.30075,  0.30639]
    )
  end

  def test_inverse_matrix_again
    a = Matrix(
      [9, 3, 0, 9],
      [-5, -2, -6, -3],
      [-4, 9, 6, 4],
      [-7, 6, 6, 2]
    )
    assert_equal a.inverse, Matrix(
      [-0.04074, -0.07778, 0.14444, -0.22222],
      [-0.07778, 0.03333, 0.36667, -0.33333],
      [-0.02901, -0.14630, -0.10926, 0.12963],
      [0.17778, 0.06667, -0.26667, 0.33333]
    )
  end

  def test_multiplying_a_product_by_its_inverse
    a = Matrix(
      [3, -9, 7, 3],
      [3, -8, 2, -9],
      [-4, 4, 4, 1],
      [-6, 5, -1, 1]
    )
    b = Matrix(
      [8, 2, 2, 2],
      [3, -1, 7, 0],
      [7, 0, 5, 4],
      [6, -2, 0, 5]
    )
    c = a * b
    c_b_inv = c * b.inverse
    c_b_inv.rows.each { |row| row.map! { |i| i.round(0) } }
    assert_equal c_b_inv, a
  end

  def test_view_transformation_matrix_for_the_default_orientation
    from = Point(0, 0, 0)
    to = Point(0, 0, -1)
    up = Vector(0, 1, 0)
    t = Matrix.view_transform(from: from, to: to, up: up)
    assert_equal t, Matrix.identity
  end

  def test_view_transformation_matrix_looking_in_positive_z_direction
    from = Point(0, 0, 0)
    to = Point(0, 0, 1)
    up = Vector(0, 1, 0)
    t = Matrix.view_transform(from: from, to: to, up: up)
    assert_equal t, scaling(-1, 1, -1)
  end

  def test_view_transformation_moves_the_world
    from = Point(0, 0, 8)
    to = Point(0, 0, 0)
    up = Vector(0, 1, 0)
    t = Matrix.view_transform(from: from, to: to, up: up)
    assert_equal t, translation(0, 0, -8)
  end

  def test_arbitrary_view_transformation
    from = Point(1, 3, 2)
    to = Point(4, -2, 8)
    up = Vector(1, 1, 0)
    t = Matrix.view_transform(from: from, to: to, up: up)
    expected = Matrix(
      [-0.50709, 0.50709, 0.67612, -2.36643],
      [0.76772, 0.60609, 0.12122, -2.82843],
      [-0.35857, 0.59761, -0.71714, 0.00000],
      [0.00000, 0.00000, 0.00000, 1.00000]
    )
    assert expected.approx_equal(t)
  end
end
