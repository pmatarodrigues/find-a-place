# frozen_string_literal: true

class ReadDifferentPlacesInteractor
    def call(aggregator:)
        # get all results
        recent_places_result = aggregator.results_list

        # read previously saved places
        previous_places_result = FileContent.read(filename: aggregator.filename)
        previous_places_result = JSON.parse(previous_places_result) if previous_places_result
        previous_places_result ||= {}

        [recent_places_result, previous_places_result]
    end
  end
  