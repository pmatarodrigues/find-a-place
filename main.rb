# frozen_string_literal: true

require_relative 'utils/files'
require_relative 'utils/common'

require_relative 'aggregators/imovirtual'
require_relative 'aggregators/olx'

require_relative 'interactors/identify_different_places_interactor'
require_relative 'interactors/save_places_data_interactor'

aggregators = [
  IMOVIRTUAL,
  OLX
]

def main(aggregators)
  identify_different_places_interactor = IdentifyDifferentPlacesInteractor.new
  save_different_places_interactor = SaveDifferentPlacesInteractor.new

  aggregators.each do |aggregator|
    recent_places_result, previous_places_result = read_results(aggregator)

    different_places = identify_different_places_interactor.call(
      name: aggregator.name,
      previous_places: previous_places_result,
      recent_places: recent_places_result
    )

    save_different_places_interactor.call(
      recent_places: recent_places_result,
      different_places: different_places,
      aggregator: aggregator
    )
  end
end

def read_results(aggregator)
  # get all results
  recent_places_result = aggregator.results_list

  # read previously saved places
  previous_places_result = FileContent.read(filename: aggregator.filename)
  previous_places_result = JSON.parse(previous_places_result) if previous_places_result

  [recent_places_result, previous_places_result]
end

main(aggregators)
