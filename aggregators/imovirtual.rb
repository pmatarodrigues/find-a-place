# frozen_string_literal: true

require_relative '../entities/scraper'

IMOVIRTUAL = Scraper.new(
  name: 'Imovirtual',
  url: 'https://www.imovirtual.com/arrendar/apartamento/braga/?search%5Bfilter_float_price%3Ato%5D=600&search%5Bfilter_enum_rooms_num%5D%5B0%5D=1&search%5Bfilter_enum_rooms_num%5D%5B1%5D=2&search%5Bregion_id%5D=3&search%5Bsubregion_id%5D=36',
  aggregator_selectors: {
    section: '.col-md-content.section-listing__row-content',
    result: 'article',
    result_title: '.offer-item-title',
    result_topology: '.offer-item-rooms',
    result_price: '.offer-item-price',
    result_url: '.offer-item-header > h3 > a'
  },
  filename: 'imovirtual.json'
)
