# frozen_string_literal: true

require_relative '../entities/scraper'

IDEALISTA = Scraper.new(
  name: 'Idealista',
  url: 'https://www.idealista.pt/arrendar-casas/braga/com-preco-max_600,t1,t2/',
  aggregator_selectors: {
    section: '.items-container',
    result: 'article.item.item-multimedia-container',
    result_title: '.item-info-container .item-link',
    result_topology: '.item-info-container .item-detail-char > .item-detail',
    result_price: '.item-price h2-simulated',
    result_url: '.item-info-container .item-link'
  },
  filename: 'idealista.json'
)
