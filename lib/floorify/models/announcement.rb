module Floorify
  class Announcement
    attr_accessor(
      :id,
      :monthly_price,
      :title,
      :description,
      :deposit,
      :address,
      :size,
      :rooms,
      :floor,
      :updated_at,
      :phone,
      :adv_name,
      :adv_type,
      :pictures
    )

    def initialize(params={})
      @id             = params.fetch(:id, nil)
      @monthly_price  = params.fetch(:monthly_price, nil)
      @title          = params.fetch(:title, nil)
      @description    = params.fetch(:description, nil)
      @deposit        = params.fetch(:deposit, nil)
      @address        = params.fetch(:address, nil)
      @size           = params.fetch(:size, nil)
      @rooms          = params.fetch(:rooms, nil)
      @floor          = params.fetch(:floor, nil)
      @updated_at     = params.fetch(:updated_at, nil)
      @phone          = params.fetch(:phone, nil)
      @adv_name       = params.fetch(:adv_name, nil)
      @adv_type       = params.fetch(:adv_type, nil)
      @pictures       = params.fetch(:pictures, [])
    end

    def is_pro?
      adv_type && adv_type.include?('Profesional')
    end
  end
end
