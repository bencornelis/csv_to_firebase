class ValidateHeaders
  def initialize(headers)
    @headers = headers
  end

  def call
    headers.all? { |header| valid?(header) }
  end

private

  attr_reader :headers

  def valid?(header)
    header && valid_chars?(header)
  end

  def valid_chars?(header)
    prohibited_chars.all? { |char| !header.include?(char) }
  end

  def prohibited_chars
    %w(. $ # [ ] /)
  end
end
