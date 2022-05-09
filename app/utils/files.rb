# frozen_string_literal: true

class FileContent
  def self.save(content:, filename:)
    File.open("app/output/#{filename}", 'w') { |f| f.puts content }
  rescue StandardError
    puts 'File does not exist. \n'
  end

  def self.read(filename:)
    File.read("app/output/#{filename}").strip
  rescue StandardError
    puts 'File does not exist. \n'
  end
end
