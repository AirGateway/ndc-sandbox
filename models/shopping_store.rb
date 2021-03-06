class ShoppingStore
  require "redis"

  def self.save_request(dep, arr, date_dep, token, num_travelers)
    hash = {"dep" => dep, "arr" => arr, "date_dep" => date_dep, "num_travelers" => num_travelers}
    Redis.current.set("airshopping-" + token, hash.to_json)
    Redis.current.expire("airshopping-" + token, 3000)
  end

  def self.get_request(response_id)
    JSON.parse(Redis.current.get("airshopping-" + response_id))
  end

  def self.get_num_travelers(response_id)
    od = JSON.parse(Redis.current.get("airshopping-" + response_id))
    od["num_travelers"]
  end

  def self.get_flight_segments(token)
    JSON.parse(Redis.current.get("flight_segment-" + response_id))
  end

  def self.save_flight_segments(token, offers)
    flight_segment_keys = []
    offers.each do |offer|
      offer.flight_segments.each do |fs|
        flight_segment_keys.insert(fs.attributes["key"])
      end
    end
    Redis.current.set("flight_segment-" + token, flight_segment_keys.to_json)
    Redis.current.expire("flight_segment-" + token, 3000)
  end

  def self.get_dow_hash(dep_date)
    # this method will return hash like this: { "mon" => true, "tue" => false ... so on }
    days = [ "mon", "tue", "wed", "thu", "fri", "sat", "sun" ]
    dow_hash = {}
    days.each do |day|
      if date_dep.strftime("%a").downcase == day
        dow_hash[day] = true
      else
        dow_hash[day] = false
      end
    end
  end
end
