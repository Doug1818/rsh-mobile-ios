class User
  attr_accessor :email, :id, :first_name, :last_name

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
  end

  def self.from_json(json)
    new(
      email: json['email'],
      id: json['id'],
      first_name: json['first_name'],
      last_name: json['last_name'])
  end

  def self.subscribe_to_push_channels(user)

  end

  # def update(data, &block)
  #   data.merge( { authentication_token: App::Persistence[:program_authentication_token]} )

  #   BW::HTTP.put("#{Globals::API_ENDPOINT}/users/#{self.id}", { payload: data }) do |response|
  #     if response.ok?
  #       block.call(true, user)
  #     else
  #       block.call(false, nil)
  #     end
  #   end
  # end
end
