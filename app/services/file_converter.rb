class FileConverter
  def initialize(opened_file)
    raise "No file to convert!" unless opened_file
    @opened_file = opened_file
  end

  def convert
    (2..total_rows).map do |i|
      Hash[header.zip(opened_file.row(i))]
    end
  end

  def metadata
    {
      column_headers: header,
      rows_count:     total_rows - 1
    }
  end

private

  attr_reader :opened_file

  def header
    opened_file.row(1)
  end

  def total_rows
    opened_file.last_row
  end
end
