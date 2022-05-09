require_relative '../utils/common'
require_relative '../utils/files'

require_relative '../interactors/identify_different_places_interactor'
require_relative '../interactors/read_places_data_interactor'
require_relative '../interactors/save_places_data_interactor'

require_relative '../aggregators/imovirtual'
require_relative '../aggregators/olx'

class ApplicationController < ActionController::API

  def findaplace
    identify_different_places_interactor = IdentifyDifferentPlacesInteractor.new
    save_different_places_interactor = SaveDifferentPlacesInteractor.new
    read_different_places_interactor = ReadDifferentPlacesInteractor.new

    aggregators = [
      IMOVIRTUAL,
      OLX
    ]

    different_places = {}

    aggregators.each do |aggregator|
      recent_places_result, previous_places_result = read_different_places_interactor.call(aggregator: aggregator)

      different_places[aggregator.name] = identify_different_places_interactor.call(
        name: aggregator.name,
        previous_places: previous_places_result,
        recent_places: recent_places_result
      )

      save_different_places_interactor.update_aggregator_file(
        recent_places: recent_places_result,
        aggregator: aggregator
      )
    end

    save_different_places_interactor.update_differences_file(
      different_places: different_places,
    )
    render json: different_places
  end

end
