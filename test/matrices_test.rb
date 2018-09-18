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
end
