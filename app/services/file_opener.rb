class FileOpener
  def initialize(file)
    @file = file
  end

  def open_file
    case file_type
    when ".csv" then Roo::CSV.new(file.path)
    when ".xls" then Roo::Excel.new(file.path)
    when ".xlsx" then Roo::Excelx.new(file.path)
    end
  end

  def valid_type?
    %w(.csv .xls xlsx).include?(file_type)
  end

private

  attr_reader :file

  def file_type
    File.extname(file.original_filename)
  end
end
