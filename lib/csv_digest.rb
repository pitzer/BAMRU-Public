module CsvDigest
  def input_digest(data)
    Digest::SHA1.hexdigest(data)
  end

  def load_errors?(data)
    (input_digest(data) == CsvGenerator.new.digest) || data.blank?
  end

  def load_ready?(data)
    (! load_errors?(data)) && (! duplicate_data?(data))
  end

  def duplicate_data?(data = @input_csv)
    input_digest(data) == CsvGenerator.new.digest
  end
end