# frozen_string_literal: true

class IdentifyDifferentPlacesInteractor
  def call(name:, previous_places:, recent_places:)
    different_places = {}

    recent_places.each do |checksum, place|
      if previous_places.nil? || !previous_places[checksum]
        different_places[checksum] = {
          diff: 'new',
          place: place,
        }
      elsif changed?(place)
        different_places[checksum] = {
          diff: 'updated',
          place: place,
        }
      end

      previous_places.delete(checksum)
    end

    previous_places.each do |checksum, place|
      different_places[checksum] = {
        diff: 'deleted',
        place: place,
      }
    end
    
    return [] unless different_places.length.positive?

    puts "There's new results available on #{name}"
    different_places
  end

  private

  def changed?(current_place)
    return false if (current_place.nil? || current_place[:previous_checksum].nil?)

    place_to_get_checksum = current_place.except(:previous_checksum)
    
    current_place[:previous_checksum] != Digest::MD5.hexdigest(Marshal.dump(place_to_get_checksum.to_s))
  end
end
