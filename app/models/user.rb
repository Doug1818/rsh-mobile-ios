class User
  attr_accessor :email, :id, :first_name, :last_name, :phone, :timezone, :avatar

  def initialize(attrs)
    attrs.each_pair do |key, value|
      self.send("#{key}=", value)
    end
  end

  def persist_data
    App::Persistence[:user_email] = self.email if self.email
    App::Persistence[:user_id] = self.id if self.id
    App::Persistence[:user_first_name] = self.first_name if self.first_name
    App::Persistence[:user_last_name] = self.last_name if self.last_name
    App::Persistence[:user_full_name] = "#{ self.first_name } #{ self.last_name }" if self.first_name and self.last_name
    App::Persistence[:user_phone] = self.phone if self.phone
    App::Persistence[:user_timezone] = self.timezone if self.timezone
  end

  def self.from_json(json)
    new(
      email: json['email'],
      id: json['id'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      avatar: json['avatar']['large']['url'],
      phone: json['phone'],
      timezone: json['timezone'])
  end

  def self.get_profile(&block)
    data = { authentication_token: App::Persistence[:program_authentication_token] }
    BW::HTTP.get("#{Globals::API_ENDPOINT}/users", { payload: data }) do |response|
      if response.ok?
        json_data = BW::JSON.parse(response.body.to_str)[:data]
        
        user = json_data["user"].map {|u|
          User.from_json(u)
        }
        block.call(true, user.first)
      else
        block.call(false, nil)
      end
    end
  end

  def self.update_profile(data, &block)

    data.merge!({ authentication_token: App::Persistence[:program_authentication_token] })

    BW::HTTP.put("#{Globals::API_ENDPOINT}/users/#{App::Persistence[:user_id]}", { payload: data }) do |response|
      if response.ok?
        json_data = BW::JSON.parse(response.body.to_str)[:data]
        user = json_data[:user]
        block.call(true, user)
      else
        block.call(false, nil)
      end
    end
  end
end
