class CheckIn
  def initialize(attrs)
    attrs.each_pair do |key, value|
      self.send("#{key}=", value)
    end
  end

  def self.create(data, &block)

    data.merge!({ authentication_token: App::Persistence[:program_authentication_token] })

    BW::HTTP.post("#{Globals::API_ENDPOINT}/check_ins", { payload: data }) do |response|
      if response.ok?
        block.call(true)
      else
        block.call(false)
      end
    end
  end

  def self.update(data, check_in, &block)

    data.merge!({ authentication_token: App::Persistence[:program_authentication_token] })

    BW::HTTP.put("#{Globals::API_ENDPOINT}/check_ins/#{ check_in }", { payload: data }) do |response|
      if response.ok?
        block.call(true)
      else
        block.call(false)
      end
    end
  end
end
