module Screen
 class CheckInScreen < PM::Screen

    attr_accessor :date
    attr_accessor :is_update

    TAGS = { day_label: 2, small_step_name_label: 3, no_button: 4, yes_button: 5, cancel_button: 6 }

    # def loadView
    def on_load
      self.title = ''
      self.date
      self.is_update

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

        @date = self.date || NSDate.today
        date_string_for_label = @date.string_with_format('MMM d')

        @is_update = self.is_update || false

        if @is_update
          @cancel_button = view.viewWithTag TAGS[:cancel_button]
          @cancel_button.alpha = 1
          @cancel_button.addTarget(self, action: "cancel_action", forControlEvents: UIControlEventTouchUpInside)
        end

        @day_label.text = date_string_for_label
        get_small_steps(@date)
      end
    end

    def get_small_steps(date)

      data = {
        authentication_token: App::Persistence[:program_authentication_token],
        date: date,
        is_update: @is_update
      }

      BW::HTTP.get("#{Globals::API_ENDPOINT}/week/small_steps_for_day", { payload: data }) do |response|
        if response.ok?
          json_data = BW::JSON.parse(response.body.to_str)[:data]
          @week = json_data[:week]
          @small_steps = @week[:small_steps]

          today_or_yesterday = (date == NSDate.today) ? 'today': 'yesterday'

          if @small_steps.count == 1
            small_step_name = @small_steps.first['name']
            @small_step_name_label.text = "Did you do your #{ small_step_name.downcase } for #{ today_or_yesterday }?"
          elsif @small_steps.count > 1
            @small_step_name_label.text = "Did you do your steps #{ today_or_yesterday }?"
          else
            @small_step_name_label.text = "No steps for #{ today_or_yesterday }."
          end

        elsif response.status_code.to_s =~ /40\d/
          App.alert("There was an error")
        else
          App.alert(response.error_message)
        end
      end
    end

    def cancel_action
      screen = DayScreen.new(nav_bar: true, date: @date)
      mm_drawerController.centerViewController = screen
    end

    def answer_no
      if @is_update
        update_check_in(0)
      else
        create_check_in(0)
      end
    end

    def answer_yes
      if @is_update
        update_check_in(1)
      else
        create_check_in(1)
      end
    end

    def create_check_in(status)

      if @small_steps.count > 0

        data = {
          authentication_token: App::Persistence[:program_authentication_token],
          week_id: @week[:id],
          date: @date,
          status: status,
          small_steps: @small_steps
        }

        BW::HTTP.post("#{Globals::API_ENDPOINT}/check_ins", { payload: data }) do |response|
          if response.ok?
            screen = mm_drawerController.send(:thank_you_screen)
            mm_drawerController.centerViewController = screen
           elsif response.status_code.to_s =~ /40\d/
            App.alert("There was an error")
          else
            App.alert(response.error_message)
          end
        end
      end
    end

    def update_check_in(status)

      if @small_steps.count > 0
        data = {
          authentication_token: App::Persistence[:program_authentication_token],
          week_id: @week[:id],
          date: @date,
          status: status,
          small_steps: @small_steps
        }

        check_in = @week[:check_in_id]

        BW::HTTP.post("#{Globals::API_ENDPOINT}/check_ins/update/#{ check_in }", { payload: data }) do |response|
          if response.ok?
            screen = mm_drawerController.send(:thank_you_screen)
            mm_drawerController.centerViewController = screen
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
