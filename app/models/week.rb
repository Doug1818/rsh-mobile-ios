class Week
  attr_accessor :start_date, :days

  def initialize(attrs)
    attrs.each_pair do |key, value|
      self.send("#{key}=", value)
    end
  end

  def self.from_json(json)
    # instantiate a Week instance
    new(start_date: json['start_date'], days: json['days'])
  end

  def self.get_week(&block)
    data = { 
      authentication_token: App::Persistence[:authentication_token],
      date: NSDate.today
    }
    BW::HTTP.get("#{Globals::API_ENDPOINT}/weeks", { payload: data }) do |response|
      if response.ok?
        json_data = BW::JSON.parse(response.body.to_str)[:data]
        week = json_data["week"].map {|w|
          Week.from_json(w)
        }

        block.call(true, week)
      else
        block.call(false, nil)
      end
    end
  end
end
