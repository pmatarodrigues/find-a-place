# frozen_string_literal: true

class IdentifyDifferentPlacesInteractor
  def call(name:, previous_places:, recent_places:)
    different_places = {}

    recent_places.each do |checksum, place|
      different_places[checksum] = place unless previous_places[checksum]

      different_places[checksum] = place if changed?(checksum, previous_places[checksum])
    end

    return [] unless different_places.length.positive?

    puts "There's new results available on #{name}"
    different_places
  end

  private

  def changed?(checksum, place)
    checksum != Digest::MD5.hexdigest(Marshal.dump(place.to_s))
  end
end
