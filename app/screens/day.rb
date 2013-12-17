module Screen
 class Day < PM::Screen

    title 'Day View'

    TAGS = {day_label: 2, small_step_name_label: 3, no_button: 4, yes_button: 5}
  
    def loadView
      views = NSBundle.mainBundle.loadNibNamed "day_view", owner:self, options:nil
      self.view = views[0]
    end

    def viewDidLoad
      @day_label = view.viewWithTag TAGS[:day_label]
      @small_step_name_label = view.viewWithTag TAGS[:small_step_name_label]
      @small_step_name_label.sizeToFit

      no_button = view.viewWithTag TAGS[:no_button]
      no_button.addTarget(self, action: "answer_no", forControlEvents: UIControlEventTouchUpInside)

      yes_button = view.viewWithTag TAGS[:yes_button]
      yes_button.addTarget(self, action: "answer_yes", forControlEvents: UIControlEventTouchUpInside)

      data = {authentication_token: App::Persistence[:authentication_token]}
      get_weeks
    end

    def get_weeks
      data = {authentication_token: App::Persistence[:authentication_token]}

      BW::HTTP.get("http://localhost:3000/api/v1/weeks", { payload: data }) do |response|
        if response.ok?
          @weeks = BW::JSON.parse(response.body.to_str)[:data][:weeks]
          update_result()
        elsif response.status_code.to_s =~ /40\d/
          App.alert("There was an error")
        else
          App.alert(response.error_message)
        end
      end
    end

    def update_result
      p @weeks

      # Test with the first week
      get_day(@weeks.first)
    end

    def get_day(week)

      data = {authentication_token: App::Persistence[:authentication_token]}
      BW::HTTP.get("http://localhost:3000/api/v1/weeks/#{ week }", { payload: data }) do |response|
        if response.ok?
          json_data = BW::JSON.parse(response.body.to_str)[:data]
          week = json_data[:week]

          date_array = week[:start_date].split('-')
          year = date_array[0]
          month = date_array[1]
          day = date_array[2]

          date = NSDate.from_components(year: year, month: month, day: day)
          date_string = date.string_with_format('MMM d')
          @day_label.text = date_string

          # Test with the first small step
          small_step_name = week[:small_steps].first[:name]
          @small_step_name_label.text = "Did you #{ small_step_name.downcase }?"

        elsif response.status_code.to_s =~ /40\d/
          App.alert("There was an error")
        else
          App.alert(response.error_message)
        end
      end
    end

    def answer_no
      puts "Answering NO"
    end

    def answer_yes
      puts "Answering YES"
    end
  end
end