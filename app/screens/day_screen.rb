module Screen
  class DayScreen < PM::Screen

    attr_accessor :date

    stylesheet :day_styles
    TAGS = { header_label: 2, small_steps_label: 3, notes_label: 5}

    def on_load
      @date = self.date || NSDate.today
      self.title = @date.string_with_format('MMM d')
      @views = NSBundle.mainBundle.loadNibNamed "day_view", owner:self, options:nil
    end

    def will_appear
      super

      @view_is_set_up ||= begin
        mm_drawerController.title = title

        view.subviews.each &:removeFromSuperview
        self.view = @views[0]

        layout(self.view, :main_view) do
          subview(UIView, :program_nav) do
            @day_btn = subview(UIButton.buttonWithType(UIButtonTypeRoundedRect), :day_btn)
            @week_btn = subview(UIButton.buttonWithType(UIButtonTypeRoundedRect), :week_btn)
            @month_btn = subview(UIButton.buttonWithType(UIButtonTypeRoundedRect), :month_btn)
          end

          @check_in_status = subview(UIView, :check_in_status) do
            @check_in_status_image = subview(UIImageView.alloc.init, :check_in_status_image)
          end

          @day_btn.when_tapped do
            screen = mm_drawerController.send(:day_screen)
            mm_drawerController.centerViewController = screen
          end

          @week_btn.when_tapped do
            screen = mm_drawerController.send(:week_screen)
            mm_drawerController.centerViewController = screen
          end

          @month_btn.when_tapped do
            screen = mm_drawerController.send(:month_screen)
            mm_drawerController.centerViewController = screen
          end
        end

        @header_label = view.viewWithTag TAGS[:header_label]
        @header_label.text = if @date == NSDate.today
          "Today's Steps"
        elsif @date == NSDate.today.delta(days:-1)
          "Yesterday's Steps"
        else
          "Steps for #{ @date.string_with_format('MMMM d, YYYY') }"
        end

        @small_steps_label = view.viewWithTag TAGS[:small_steps_label]
        @small_steps_label.sizeToFit

        # @notes_label = view.viewWithTag TAGS[:notes_label] - TODO
      end
      get_program_data
    end

    private

    def get_program_data

      data = {
        authentication_token: App::Persistence[:program_authentication_token],
        date: @date
      }
      BW::HTTP.get("#{Globals::API_ENDPOINT}/programs", { payload: data }) do |response|
        if response.ok?
          json_data = BW::JSON.parse(response.body.to_str)[:data]

          @program = json_data[:program]

          # Set the check in status at the top
          if NSDate.today > @date.delta(days:+1)
            @check_in_status.backgroundColor = "#6d6e71".to_color
            @check_in_status_image.image = UIImage.imageNamed('missed_checkin_alt.png')
          else
            case @program['check_in_status']
            when 1
              @check_in_status.backgroundColor = "#ffa720".to_color
              @check_in_status_image.image = UIImage.imageNamed('check-in-mixed-alt')
            when 2
              @check_in_status.backgroundColor = "#ffa720".to_color
              @check_in_status_image.image = UIImage.imageNamed('check-in-yes-alt')
            when 3
              @check_in_status.backgroundColor = "#6d6e71".to_color
              @check_in_status_image.image = UIImage.imageNamed("check-in-no-alt")
            else
            end
          end

          @check_in_status.when_tapped do 
            case @date
            when NSDate.today, NSDate.today.delta(days:-1)
              screen = CheckInScreen.new(nav_bar: true, date: @date, is_update: true)
              mm_drawerController.centerViewController = screen
            else
              App.alert("You can't edit this check-in because it happened more than 48 hours ago.")
            end
          end

          # List the small steps for the day
          @small_steps = @program['small_steps'] || []

          small_step_data = Array.new
          @small_steps.each do |small_step|
            small_step_data << small_step[:name] if small_step[:can_check_in]
          end

          unless small_step_data.empty?
            @small_steps_label.text = small_step_data.join("\n")
          else
            @small_steps_label.text = "No steps for the day"
          end

        elsif response.status_code.to_s =~ /40\d/
          App.alert("There was an error")
        else
          App.alert(response.error_message)
        end
      end
    end
  end
end
