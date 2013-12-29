module Screen
 class CheckInScreen < PM::Screen

    attr_accessor :date

    TAGS = { day_label: 2, small_step_name_label: 3, no_button: 4, yes_button: 5, not_sure_button: 6 }

    # def loadView
    def on_load
      self.title = ''
      self.date
      @views = NSBundle.mainBundle.loadNibNamed "check_in_view", owner:self, options:nil
    end

    def will_appear
      @view_is_set_up ||= begin
        mm_drawerController.title = title

        view.subviews.each &:removeFromSuperview
        self.view = @views[0]

        @day_label = view.viewWithTag TAGS[:day_label]
        @small_step_name_label = view.viewWithTag TAGS[:small_step_name_label]
        @small_step_name_label.sizeToFit

        @no_button = view.viewWithTag TAGS[:no_button]
        @no_button.addTarget(self, action: "answer_no", forControlEvents: UIControlEventTouchUpInside)

        @yes_button = view.viewWithTag TAGS[:yes_button]
        @yes_button.addTarget(self, action: "answer_yes", forControlEvents: UIControlEventTouchUpInside)

        @not_sure_button = view.viewWithTag TAGS[:not_sure_button]
        @not_sure_button.addTarget(self, action: "not_sure_action", forControlEvents: UIControlEventTouchUpInside)

        @date = self.date || NSDate.today
        date_string_for_label = @date.string_with_format('MMM d')

        @day_label.text = date_string_for_label
        get_small_steps(@date)
      end
    end

    def get_small_steps(date)

      data = {
        authentication_token: App::Persistence[:authentication_token],
        date: date
      }
      BW::HTTP.get("#{Globals::API_ENDPOINT}/week/by_date", { payload: data }) do |response|
        if response.ok?
          json_data = BW::JSON.parse(response.body.to_str)[:data]

          @week = json_data[:week].first
          @small_steps = @week[:small_steps]

          today_or_yesterday = (date == NSDate.today) ? 'today': 'yesterday'

          if @small_steps.count == 1
            small_step_name = @small_steps.first[:name]
            @small_step_name_label.text = "Did you do your #{ small_step_name.downcase } for #{ today_or_yesterday }?"
          elsif @small_steps.count > 1
            @small_step_name_label.text = "Did you do your steps #{ today_or_yesterday }?"
          else
            @small_step_name_label.text = "No small steps for today." # Should never see this, because they should only be able to get to a day with at least 1 small step.
          end

        elsif response.status_code.to_s =~ /40\d/
          App.alert("There was an error")
        else
          App.alert(response.error_message)
        end
      end
    end

    def not_sure_action
      App.alert("TODO: Handle not sure event")
    end

    def answer_no
      process_check_in(0)
    end

    def answer_yes
      process_check_in(1)
    end

    def process_check_in(status)
      if @small_steps.count > 0
        data = {
          authentication_token: App::Persistence[:authentication_token],
          small_steps: @small_steps,
          week_id: @week[:id],
          date: @date,
          status: status
        }
        BW::HTTP.post("#{Globals::API_ENDPOINT}/check_ins", { payload: data }) do |response|
          if response.ok?
            App.alert("Successfully checked in")
           elsif response.status_code.to_s =~ /40\d/
            App.alert("There was an error")
          else
            App.alert(response.error_message)
          end
        end
      end
    end
  end
end
