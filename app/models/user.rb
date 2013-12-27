class User
  attr_accessor :email, :id, :first_name, :last_name

  def initialize(attrs)
    attrs.each_pair do |key, value|
      self.send("#{key}=", value)
    end
  end

  def self.from_json(json)
    new(email: json['email'], id: json['id'], first_name: json['first_name'], last_name: json['last_name'])
  end
end
