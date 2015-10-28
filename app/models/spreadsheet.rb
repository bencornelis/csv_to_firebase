class Spreadsheet
  delegate :row, :last_row, to: :opened_file

  def self.build(file)
    new(OpenFile.new(file).call)
  end

  def initialize(opened_file)
    @opened_file = opened_file
  end

  def to_a
    (headers_idx + 1 .. last_row).map { |i| Hash[headers.zip(row(i))] }
  end

  def metadata
    {
      headers:    headers,
      rows_count: rows_count
    }
  end

  def headers
    row(headers_idx)
  end

private

  attr_reader :opened_file

  def rows_count
    last_row - headers_idx
  end

  def headers_idx
    @headers_idx ||= find_headers_idx
  end

  # finds first row with any nonempty entries
  def find_headers_idx
    (1..last_row).find { |i| !row_empty?(i) }
  end

  def row_empty?(i)
    row(i).all?(&:nil?)
  end
end
