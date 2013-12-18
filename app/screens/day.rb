module Screen
 class Day < PM::Screen

    title ''

    TAGS = {day_label: 2, small_step_name_label: 3, no_button: 4, yes_button: 5, not_sure_button: 6}

    def loadView
      views = NSBundle.mainBundle.loadNibNamed "day_view", owner:self, options:nil
      self.view = views[0]
    end

    def viewDidLoad
      @day_label = view.viewWithTag TAGS[:day_label]
      @small_step_name_label = view.viewWithTag TAGS[:small_step_name_label]
      @small_step_name_label.sizeToFit

      @no_button = view.viewWithTag TAGS[:no_button]
      @no_button.addTarget(self, action: "answer_no", forControlEvents: UIControlEventTouchUpInside)

      @yes_button = view.viewWithTag TAGS[:yes_button]
      @yes_button.addTarget(self, action: "answer_yes", forControlEvents: UIControlEventTouchUpInside)

      @not_sure_button = view.viewWithTag TAGS[:not_sure_button]
      @not_sure_button.addTarget(self, action: "not_sure_action", forControlEvents: UIControlEventTouchUpInside)

      @date = NSDate.today
      date_string_for_label = @date.string_with_format('MMM d')

      @day_label.text = date_string_for_label
      get_small_steps(@date)
    end

    def get_small_steps(date)

      data = {
        authentication_token: App::Persistence[:authentication_token],
        date: date
      }
      BW::HTTP.get("#{Globals::API_ENDPOINT}/weeks", { payload: data }) do |response|
        if response.ok?
          json_data = BW::JSON.parse(response.body.to_str)[:data]

          @week = json_data[:week].first
          @small_steps = json_data[:week].first[:small_steps]

          if @small_steps.count > 0
            small_step_name = @small_steps.first[:name]
            @small_step_name_label.text = "Did you #{ small_step_name.downcase }?"
          else
            @small_step_name_label.text = "You're all checked in!"
          end

        elsif response.status_code.to_s =~ /40\d/
          App.alert("There was an error")
        else
          App.alert(response.error_message)
        end
      end
    end

    def not_sure_action
      alert = UIAlertView.alloc.init
      alert.message = "TODO: Handle not sure event"
      alert.addButtonWithTitle "OK"
      alert.show
    end

    def answer_no
      process_check_in(0)
    end

    def answer_yes
      process_check_in(1)
    end

    def process_check_in(status)
      @small_step = @small_steps.first

      if @small_step.has_key? :id
        puts "Answering #{ status == 0 ? "No" : "Yes" } for #{ @small_step[:id] }"

        data = {
          authentication_token: App::Persistence[:authentication_token],
          small_step_id: @small_step[:id],
          week_id: @week[:id],
          date: @date,
          status: status
        }
        BW::HTTP.post("#{Globals::API_ENDPOINT}/check_ins", { payload: data }) do |response|
          if response.ok?
            load_next_small_step
           elsif response.status_code.to_s =~ /40\d/
            App.alert("There was an error")
          else
            App.alert(response.error_message)
          end
        end
      end
    end

    def load_next_small_step
      @small_steps.shift

      if @small_steps.count > 0
        small_step_name = @small_steps.first[:name]
        @small_step_name_label.text = "Did you #{ small_step_name.downcase }?"
      else
        @small_step_name_label.text = "You're all checked in!"
        @yes_button.enabled = false
        @no_button.enabled = false
      end
    end
  end
end
