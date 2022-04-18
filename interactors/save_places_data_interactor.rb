# frozen_string_literal: true

class SaveDifferentPlacesInteractor
  def call(recent_places:, different_places:, aggregator:)
    FileContent.save(content: recent_places.to_json, filename: aggregator.filename)

    FileContent.save(content: different_places.to_json, filename: "different_#{aggregator.filename}")
  end
end
