module Floorify
  module Idealista
    class Finder
      attr_reader :announcements

      def initialize(params={})
        @url           = params.fetch(:url, nil)
        @interval      = params.fetch(:interval, 5)
        @only_private  = params.fetch(:only_private, true)
        @debug_mode    = params.fetch(:debug_mode, false)
        @announcements = []
      end

      def latest
        announcements.each_with_index do |announcement, index|
          unless is_advertisement?(announcement)
            id         = get_id(announcement)
            updated_at = get_updated_at(announcement)
            get_item(id) if updated_minutes_ago?(updated_at)
            print_debugger(index, id, updated_at) if @debug_mode
          end
        end
        @announcements
      end

      private

        def page
          HTTParty.get(@url)
        rescue Errno::ECONNREFUSED => ex
          nil
        end

        def parse_page(paged)
          Nokogiri::HTML(paged)
        end

        def announcements
          parsed_page = parse_page(page)
          parsed_page.css('.items-container').css('article')
        end

        def is_advertisement?(item)
          item.attributes['class'].value.include?('adv') if item.attributes['class']
        end

        def get_id(item)
          item.css('.item').attr('data-adid').value
        end

        def get_updated_at(item)
          updated_at = item.css('.item').css('.txt-highlight-red')
          updated_at ? updated_at.text : ''
        end

        def updated_minutes_ago?(updated_at)
          TimeAnalyzer.new(updated_at).minutes_ago?(@interval)
        end

        def get_item(id)
          announcement = Idealista::Item.new(id: id).process
          if @only_private
            @announcements << announcement if !announcement.is_pro?
          else
            @announcements << announcement
          end
        end

        def print_debugger(index, id, updated_at)
          puts "Announcement #{index} ----------------------"
          puts " id: #{id}"
          puts " updated_at: #{updated_at}"
        end
    end
  end
end
