# frozen_string_literal: true

require 'nokogiri'
require 'httparty'

class Scraper
  attr_reader :name, :url, :parsed_page, :aggregator_selectors, :filename

  def initialize(name:, url:, aggregator_selectors:, filename:)
    @name = name
    @url = url
    @aggregator_selectors = aggregator_selectors
    @filename = filename

    puts "Reading ::#{name}::"

    response = HTTParty.get(url)
    @parsed_page = Nokogiri::HTML(response.body)
  end

  def results_list
    results = {}
    all_results.each do |result|
      single_result_data = single_result_data(result)
      single_result_data[:previous_checksum] = Digest::MD5.hexdigest(Marshal.dump(single_result_data.to_s))
      
      results[Digest::MD5.hexdigest(Marshal.dump(single_result_data[:url].to_s))] = single_result_data
    end

    results
  end

  def self.look_for_differences(recent:, previous:)
    (recent - previous) | (previous - recent)
  end

  private

  def all_results
    parsed_page.css("#{aggregator_selectors[:section]} #{aggregator_selectors[:result]}")
  end

  # rubocop:disable Metrics/AbcSize
  def single_result_data(result)
    {
      title: result.css(aggregator_selectors[:result_title]).text,
      topology: aggregator_selectors[:result_topology] ? result.css(aggregator_selectors[:result_topology]).first.text : 'N/A',
      price: result.css(aggregator_selectors[:result_price]).first.text.delete('^0-9'),
      url: result.css(aggregator_selectors[:result_url]).first['href'],
    }
  end
  # rubocop:enable Metrics/AbcSize
end
