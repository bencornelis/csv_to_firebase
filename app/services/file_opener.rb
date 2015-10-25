class FileOpener
  def initialize(file)
    @file = file
  end

  def open_file
    case file_type
    when ".csv" then Roo::CSV.new(file.path)
    when ".xls" then Roo::Excel.new(file.path)
    when ".xlsx" then Roo::Excelx.new(file.path)
    else
      raise "Invalid file type: #{file_type}."
    end
  end

private

  attr_reader :file

  def file_type
    File.extname(file.original_filename)
  end
end
