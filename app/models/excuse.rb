class Excuse
  attr_accessor :name

  def initialize(attrs)
    attrs.each_pair do |key, value|
      self.send("#{key}=", value)
    end
  end

  def self.get_excuses(&block)

    data = { authentication_token: App::Persistence[:program_authentication_token] }
    BW::HTTP.get("#{Globals::API_ENDPOINT}/excuses", { payload: data }) do |response|
      if response.ok?
        json_data = BW::JSON.parse(response.body.to_str)[:data]

        excuses = json_data['excuses']
        block.call(true, excuses)
      else
        puts "RESPONSE NOT OK"
        block.call(false, nil)
      end
    end
  end
end
