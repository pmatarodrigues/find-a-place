# frozen_string_literal: true

require_relative '../acceptance_helper'

describe IdentifyDifferentPlacesInteractor do
  let(:identify_different_places_interactor) do
    IdentifyDifferentPlacesInteractor.new
  end
  let(:previous_places_result) do
    {
      '0a0bf07894434a8b67c9a8bbd90d4583' => {
        title: 'T2+1 - S. VITOR',
        topology: 'T2',
        price: '600',
        url: 'https://www.imovirtual.com/pt/anuncio/t2-1-s-vitor-ID18vep.html#51f25bc3c8',
        previous_checksum: 'ce3db0ed694b3c1bb36d509158b03780',
      },
      '91f20b37292ee498ac08a9773f127238' => {
        title: 'Apartamento T1 para arrendamento Zona Nobre',
        topology: 'T1',
        price: '600',
        url: 'https://www.imovirtual.com/pt/anuncio/apartamento-t1-para-arrendamento-zona-nobre-ID18dOH.html#51f25bc3c8',
        previous_checksum: 'a29175c7fe04a7eddb5f55ff4a101b31',
      }
    }
  end
  let(:aggregator) do
    IMOVIRTUAL
  end

  context 'when nothing changed' do
    it 'returns different_places as empty' do
      different_places = identify_different_places_interactor.call(
        name: aggregator.name,
        previous_places: previous_places_result,
        recent_places: previous_places_result
      )

      expect(different_places).to be_empty
    end
  end

  context 'when there\'s differences' do
    context 'when new places were added' do
      let(:new_place_checksum) do
        'b0611cc3b5486fd340a9ef946838fa67'
      end
      let(:new_place_data) do
        {
          title: 'Apartamento T2 para arrendamento',
          topology: 'T2',
          price: '600',
          url: 'https://www.imovirtual.com/pt/anuncio/apartamento-t2-para-arrendamento-ID18wIU.html#51f25bc3c8',
          previous_checksum: '987b3919c05eb13671f5f723e972b7fa',
        }
      end

      it 'sends a message with new places data' do
        allow(identify_different_places_interactor).to receive(:convert_hash_to_checksum)

        recent_places_result = previous_places_result.dup
        recent_places_result[new_place_checksum] = new_place_data

        different_places = identify_different_places_interactor.call(
          name: aggregator.name,
          previous_places: previous_places_result,
          recent_places: recent_places_result
        )

        expect(different_places).to eq(
          {
            new_place_checksum => {
              diff: 'new',
              place: new_place_data,
            }
          }
        )
      end
    end

    context 'when an existing place was changed' do
      let(:updated_place_data) do
        {
          title: 'Apartamento T1 para arrendamento Zona Nobre',
          topology: 'T1',
          price: '900',
          url: 'https://www.imovirtual.com/pt/anuncio/apartamento-t1-para-arrendamento-zona-nobre-ID18dOH.html#51f25bc3c8',
          previous_checksum: 'a29175c7fe04a7eddb5f55ff4a101b31',
        }
      end
      let(:updated_place_checksum) do
        '91f20b37292ee498ac08a9773f127238'
      end
      
      it 'sends a message with updated places' do
        recent_places_result = previous_places_result.dup
        recent_places_result[updated_place_checksum] = updated_place_data

        different_places = identify_different_places_interactor.call(
          name: aggregator.name,
          previous_places: previous_places_result,
          recent_places: recent_places_result
        )

        expect(different_places).to eq(
          {
            updated_place_checksum => {
              diff: 'updated',
              place: updated_place_data,
            }
          }
        )
      end
    end

    context 'when an existing place was removed' do
      let(:removed_place_data) do
        {
          title: 'Apartamento T1 para arrendamento Zona Nobre',
          topology: 'T1',
          price: '600',
          url: 'https://www.imovirtual.com/pt/anuncio/apartamento-t1-para-arrendamento-zona-nobre-ID18dOH.html#51f25bc3c8',
          previous_checksum: 'a29175c7fe04a7eddb5f55ff4a101b31',
        }
      end
      let(:removed_place_checksum) do
        '91f20b37292ee498ac08a9773f127238'
      end

      it 'sends message with removed place' do
        recent_places_result = previous_places_result.except(removed_place_checksum)

        different_places = identify_different_places_interactor.call(
          name: aggregator.name,
          previous_places: previous_places_result,
          recent_places: recent_places_result
        )

        expect(different_places).to eq(
          {
            removed_place_checksum => {
              diff: 'deleted',
              place: removed_place_data,
            }
          }
        )
      end
    end
  end
end
