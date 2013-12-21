class WeekData
  def self.get_weeks(delegate)
    data = {
      authentication_token: App::Persistence[:authentication_token]
    }
    BW::HTTP.get("#{Globals::API_ENDPOINT}/weeks", { payload: data }) do |response|
      if response.ok?
        json_data = BW::JSON.parse(response.body.to_str)[:data]
        puts "JSON_DATA: #{ json_data }"
        puts "JSON_DATA_WEEKS: #{ json_data['weeks'] }"
        result_data = json_data['weeks']

        delegate.load_data(result_data)
        delegate.view.reloadData

        # puts json_data
      elsif response.status_code.to_s =~ /40\d/
        App.alert("There was an error")
      else
        App.alert(response.error_message)
      end
    end
    # puts "DATA COUNT: #{ @data.count }"
    # @data
  end
end