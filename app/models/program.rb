class Program
  attr_accessor :authentication_token, :user

  def initialize(attrs)
    attrs.each_pair do |key, value|
      self.send("#{key}=", value)
    end
  end

  def persist_data
    App::Persistence[:program_authentication_token] = self.authentication_token if self.authentication_token
  end

  def self.from_json(json)
    new(
      authentication_token: json[:program]['authentication_token'],
      user: User.from_json(json[:user]))
  end


  def self.authenticate_program(authentication_token, &block)
    data = { authentication_token: authentication_token }
    
    data.merge!({ parse_id: App::Persistence[:parse_id] }) if App::Persistence[:parse_id]

    BW::HTTP.post("#{Globals::API_ENDPOINT}/sessions", { payload: data }) do |response|
      if response.ok?
        json_data = BW::JSON.parse(response.body.to_str)[:data]
        program = Program.from_json(json_data)

        block.call(true, program)
      elsif response.status_code.to_s =~ /40\d/
        block.call(false, nil)
      else
        block.call(false, nil)
      end
    end
  end
end
