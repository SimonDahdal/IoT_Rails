module ApplicationHelper
  def get_coordinates_by_address(address)
    result = Geocoder.search(address).first
    if result.nil?
      nil
    else
      result.coordinates
    end
  end

  def get_address_by_coordinates(coordinates)
    result = Geocoder.search(coordinates).first
    if result.nil?
      nil
    else
      result.address
    end
  end
end
