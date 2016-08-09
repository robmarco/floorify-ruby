module Floorify
  module Idealista
    class List
      attr_reader :announcements

      def initialize(params={})
        @url  = params.fetch(:url, nil)
        @announcements = []
      end

      def process
        announcements.each do |announcement|
          if !is_advertisement?(announcement)
            id          = get_id(announcement)
            price       = get_price(announcement)
            title       = get_title(announcement)
            description = get_description(announcement)
            phone       = get_phone(announcement)

            details     = get_details(announcement)
            size        = get_size(details)
            rooms       = get_rooms(details)
            floor       = get_floor(details)
            updated_at  = get_updated_at(details)

            add_announcement(id, price, title, description, size, rooms, floor, updated_at, phone)
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

        def get_price(item)
          item.css('.item').css('.item-price').children.first.text
        end

        def get_phone(item)
          phone = item.css('.item').css('.icon-phone')
          phone.children.first.text if !phone.empty?
        end

        def get_title(item)
          item.css('.item').css('.item-link').text
        end

        def get_description(item)
          item.css('.item').css('.item-description').text
        end

        def get_details(item)
          item.css('.item').css('.item-detail')
        end

        def get_rooms(detail)
          detail[0].text
        end

        def get_size(detail)
          detail[1].text
        end

        def get_floor(detail)
          detail[2].text
        end

        def get_updated_at(detail)
          detail[3] ? detail[3].text : nil
        end

        def add_announcement(id, price, title, description, size, rooms, floor, updated_at, phone)
          announcement = Announcement.new(
            id: id,
            monthly_price: price,
            title: title,
            description: description,
            size: size,
            rooms: rooms,
            floor: floor,
            updated_at: updated_at,
            phone: phone
          )

          @announcements << announcement
        end
    end
  end
end
