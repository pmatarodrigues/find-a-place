# frozen_string_literal: true

class IdentifyDifferentPlacesInteractor
  def call(name:, previous_places:, recent_places:)
    different_places = {}

    recent_places.each do |checksum, place|

      different_places[checksum] = {
        diff: 'new',
        place: place,
      } unless previous_places[checksum]
      
      different_places[checksum] = {
        diff: 'updated',
        place: place,
      } if changed?(checksum, previous_places[checksum])

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

  def changed?(checksum, place)
    return false if (checksum.nil? || place.nil?)
    
    checksum != Digest::MD5.hexdigest(Marshal.dump(place.to_s))
  end
end
