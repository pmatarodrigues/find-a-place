# frozen_string_literal: true

require 'digest'
require 'json'
require 'pry'

def convert_hash_to_checksum(hash:)
  Digest::MD5.hexdigest(Marshal.dump(hash))
end
