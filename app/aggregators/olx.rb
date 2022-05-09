# frozen_string_literal: true

require_relative '../entities/scraper'

OLX = Scraper.new(
  name: 'OLX',
  url: 'https://www.olx.pt/imoveis/apartamento-casa-a-venda/apartamentos-arrenda/fraiao/?search%5Bfilter_float_price%3Ato%5D=600&search%5Bdist%5D=10',
  aggregator_selectors: {
    section: '.offers',
    result: '.offer',
    result_title: '.title-cell a > strong',
    result_price: '.price strong',
    result_url: '.title-cell a'
  },
  filename: 'olx.json'
)
