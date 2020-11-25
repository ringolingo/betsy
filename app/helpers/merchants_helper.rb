module MerchantsHelper

  def display_desc(desc)
    return desc ? "#{desc}." : ""
  end

  def change_status_btn(for_sale)
    return for_sale ? "Retire" : "Make Active"
  end
end
