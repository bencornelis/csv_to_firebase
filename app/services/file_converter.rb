class FileConverter
  def initialize(opened_file)
    raise "No file to convert!" unless opened_file
    @opened_file = opened_file
  end

  def convert
    header = opened_file.row(1)
    (2..opened_file.last_row).map do |i|
      Hash[header.zip(opened_file.row(i))]
    end
  end

private

  attr_reader :opened_file
end
