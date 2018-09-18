class Matrix
  attr_reader :rows

  def self.empty(rows, columns)
    Matrix(*Array.new(rows) { Array.new(columns) })
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
    Matrix.empty(row_size, column_size).tap do |m|
      row_size.times do |row_index|
        column_size.times do |column_index|
          m[row_index, column_index] = multiply(row_index, column_index, other)
        end
      end
    end
  end

  private

  def multiply(row_index, column_index, other)
    row_size.times.reduce(0) do |sum, n|
      sum + self[row_index, n] * other[n, column_index]
    end
  end
end

def Matrix(*rows)
  Matrix.new(*rows)
end
