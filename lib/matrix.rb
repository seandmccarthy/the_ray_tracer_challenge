class Matrix
  attr_reader :rows

  def self.empty(rows, columns, value = nil)
    Matrix(*Array.new(rows) { Array.new(columns, value) })
  end

  def self.identity(size = 4)
    empty(size, size, 0).tap do |m|
      size.times { |i| m[i, i] = 1 }
    end
  end

  def initialize(*rows)
    @rows = [*rows]
  end

  def columns
    @rows.transpose
  end

  def row_size
    @rows.size
  end

  def column_size
    @column_size ||= @rows.first.size
  end

  def [](row, col)
    @rows[row][col]
  end

  def []=(row, col, value)
    @rows[row][col] = value
  end

  def ==(other)
    rows == other.rows
  end

  def approx_equal(other)
    (0..row_size-1).each do |row|
      (0..column_size-1).each do |col|
        return false unless in_delta(self[row, col], other[row, col])
      end
    end
    true
  end

  def *(other)
    return tuple_multiply(other) if other.is_a?(Tuple)
    Matrix.empty(row_size, other.column_size).tap do |m|
      row_size.times do |row_index|
        other.column_size.times do |column_index|
          m[row_index, column_index] = multiply(row_index, column_index, other)
        end
      end
    end
  end

  def transpose
    Matrix(*rows.transpose)
  end

  def determinant
    return determinant_2x2 if row_size == 2
    column_size.times.reduce(0) do |sum, n|
      sum + cofactor(0, n) * self[0, n]
    end
  end

  def submatrix(row, col)
    sub_array = rows.map(&:dup).tap do |s|
      s.delete_at(row)
      s.each { |r| r.delete_at(col) }
    end
    Matrix(*sub_array)
  end

  def minor(row, col)
    submatrix(row, col).determinant
  end

  def cofactor(row, col)
    result = minor(row, col)
    if (row + col).even?
      result
    else
      -result
    end
  end

  def invertible?
    determinant != 0
  end

  def inverse
    @inverse ||= calculate_inverse
  end

  private

  def calculate_inverse
    inv_matrix = Matrix.empty(row_size, column_size, 0)
    row_size.times do |x|
      column_size.times do |y|
        inv_matrix[x, y] = cofactor(x, y)
      end
    end
    det = determinant.to_f
    inv_matrix.transpose.tap do |m|
      m.rows.each do |row|
        row.map! { |i| (i / det).round(5) }
      end
    end
  end

  def in_delta(a, b, delta = 0.001)
    (a - b).abs <= delta
  end

  def multiply(row_index, column_index, other)
    row_size.times.reduce(0) do |sum, n|
      sum + self[row_index, n] * other[n, column_index]
    end
  end

  def tuple_multiply(tuple)
    m = Matrix([tuple.x], [tuple.y], [tuple.z], [tuple.w])
    Tuple(*(self * m).columns.first)
  end

  def determinant_2x2
    self[0, 0] * self[1, 1] - self[0, 1] * self[1, 0]
  end
end

def Matrix(*rows)
  Matrix.new(*rows)
end
