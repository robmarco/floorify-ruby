require "floorify/version"
require 'httparty'
require 'nokogiri'

module Floorify

  autoload :Announcement, 'floorify/models/announcement'
  autoload :TimeAnalyzer, 'floorify/utils/time_analyzer'

  module Idealista
    autoload :Finder, 'floorify/scrappers/idealista/finder'
    autoload :Item, 'floorify/scrappers/idealista/item'
  end

  def self.version
    VERSION
  end

  def self.idealista(url, interval=5, only_private=false, debug_mode=false)
    Idealista::Finder.new(
      url: url,
      interval: interval,
      only_private: only_private,
      debug_mode: debug_mode
    ).latest
  end
end
