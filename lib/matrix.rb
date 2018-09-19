class Matrix
  attr_reader :rows

  def self.empty(rows, columns, value = nil)
    Matrix(*Array.new(rows) { Array.new(columns, value) })
  end

  def self.identity(size)
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
    @rows.first.size
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
    self[0, 0] * self[1, 1] - self[0, 1] * self[1, 0]
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

  private

  def multiply(row_index, column_index, other)
    row_size.times.reduce(0) do |sum, n|
      sum + self[row_index, n] * other[n, column_index]
    end
  end

  def tuple_multiply(tuple)
    m = Matrix([tuple.x], [tuple.y], [tuple.z], [tuple.w])
    Tuple(*(self * m).columns.first)
  end
end

def Matrix(*rows)
  Matrix.new(*rows)
end