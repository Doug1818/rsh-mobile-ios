class Program
  attr_accessor :authentication_token, :user

  def initialize(attrs)
    attrs.each_pair do |key, value|
      self.send("#{key}=", value)
    end
  end

  def self.from_json(json)
    new(authentication_token: json[:program]['authentication_token'], user: User.from_json(json[:user]))
  end


  def self.authenticate_program(authentication_token, &block)
    puts "IN AUTH PROGRAM"
    puts "AUTHENTICATION_TOKEN: #{authentication_token}"

    data = { authentication_token: authentication_token }
    puts "DATA IS: #{data}"

    BW::HTTP.post("#{Globals::API_ENDPOINT}/sessions", { payload: data }) do |response|
      if response.ok?
        json_data = BW::JSON.parse(response.body.to_str)[:data]
        program = Program.from_json(json_data)
        puts "PROGRAM IS: #{program.inspect}"

        block.call(true, program)
      elsif response.status_code.to_s =~ /40\d/
        block.call(false, nil)
      else
        block.call(false, nil)
      end
    end
  end

  # def self.authenticate_program(authentication_token)
  #   data = { authentication_token: authentication_token }

  #   BW::HTTP.post("#{Globals::API_ENDPOINT}/sessions", { payload: data }) do |response|
  #     if response.ok?
  #       json_data = BW::JSON.parse(response.body.to_str)[:data]

  #       Program.from_json(json_data)
  #     elsif response.status_code.to_s =~ /40\d/
  #       App.alert("We did not recognize that code. Please try again.")
  #     else
  #       App.alert(response.error_message)
  #     end
  #   end
  # end
end
