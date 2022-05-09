# frozen_string_literal: true

class SaveDifferentPlacesInteractor
  def update_differences_file(different_places:)
    FileContent.save(content: different_places.to_json, filename: "differences.json")
  end
  
  def update_aggregator_file(recent_places:, aggregator:)
    FileContent.save(content: recent_places.to_json, filename: aggregator.filename)
  end
end
