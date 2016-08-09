module Floorify
  module Idealista
    class Item

      BASE_URL = "https://www.idealista.com/inmueble/"

      def initialize(params={})
        @id = params.fetch(:id, nil)
      end

      def process
        announcement = parse_page(page)
        title       = get_title(announcement)
        price       = get_price(announcement)
        size        = get_size(announcement)
        rooms       = get_rooms(announcement)
        floor       = get_floor(announcement)
        deposit     = get_deposit(announcement)
        description = get_description(announcement)
        address     = get_address(announcement)
        updated_at  = get_updated_at(announcement)
        phone       = get_phone(announcement)
        adv_name    = get_advertiser_name(announcement)
        adv_type    = get_advertiser_type(announcement)

        build_announcement(title, price, size, rooms, floor, deposit,
                description, address, updated_at, phone, adv_name, adv_type)
      end

      private

        def page
          HTTParty.get(item_url)
        rescue Errno::ECONNREFUSED => ex
          nil
        end

        def item_url
          BASE_URL + @id.to_s
        end

        def parse_page(paged)
          Nokogiri::HTML(paged)
        end

        def get_title(item)
          item.css('section#main-info').css('h2').text.strip
        end

        def get_price(item)
          item.css('section#main-info .info-data span')[0].css('span').text
        end

        def get_size(item)
          item.css('section#main-info .info-data span')[2].text
        end

        def get_rooms(item)
          item.css('section#main-info .info-data span')[4].text
        end

        def get_floor(item)
          item.css('section#main-info .info-data span')[6].text
        end

        def get_deposit(item)
          item.css('section#main-info').css('.txt-deposit').text.strip
        end

        def get_description(item)
          item.css('section#details').css('.adCommentsLanguage').text[2..-3]
        end

        def get_address(item)
          address = item.css('#addressPromo').css('ul').css('li')
          address.size > 1 ? address[0..address.size-2].text : address.text
        end

        def get_updated_at(item)
          date = item.css('section#stats p')
          date ? date.text.gsub('Anuncio actualizado el', '').strip : nil
        end

        def get_phone(item)
          phone = item.css('#side-content .contact-phones').css('.first-phone')
          phone ? phone.text.strip : nil
        end

        def get_advertiser_name(item)
          name = item.css('#side-content').css('.advertiser-data').css('p')
          name = name ? name.text.strip : nil
        end

        def get_advertiser_type(item)
          type = item.css('#side-content').css('.advertiser-data').css('p.professional-name')
          type = type.empty? ? 'Particular' : 'Profesional'
        end

        def build_announcement(title, price, size, rooms, floor, deposit,
                description, address, updated_at, phone, adv_name, adv_type)

          Announcement.new(
            id: @id,
            monthly_price: price,
            title: title,
            description: description,
            deposit: deposit,
            address: address,
            size: size,
            rooms: rooms,
            floor: floor,
            updated_at: updated_at,
            phone: phone,
            adv_name: adv_name,
            adv_type: adv_type
          )
        end
    end
  end
end
