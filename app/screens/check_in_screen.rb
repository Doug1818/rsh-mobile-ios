module Screen
 class CheckInScreen < PM::Screen

    attr_accessor :date, :is_update, :comments

    stylesheet :check_in_styles
    TAGS = { day_label: 2, small_step_name_button: 3, no_button: 4, yes_button: 5, cancel_button: 6, excuse_button: 7, chevron: 8 }

    # def loadView
    def on_load
      self.title = 'Check-in'
      self.date
      self.is_update
      self.comments

      mm_drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeTapCenterView | MMCloseDrawerGestureModePanningCenterView
      @views = NSBundle.mainBundle.loadNibNamed "check_in_view", owner:self, options:nil
    end

    def will_appear
      @view_is_set_up ||= begin
        # mm_drawerController.title = title

        view.subviews.each &:removeFromSuperview
        self.view = @views[0]

        self.view.when_swiped do
          # mm_drawerController.setDrawerVisualStateBlock(MMDrawerVisualState.slideAndScaleVisualStateBlock())
          UIView.animateWithDuration(0.1,
            animations:lambda {
              screen = mm_drawerController.send(:week_screen)
              mm_drawerController.centerViewController = screen
            }
          )
        end.direction = UISwipeGestureRecognizerDirectionLeft

        layout(self.view, :main_view) do
          subview(UIView, :program_nav) do
            @day_btn = subview(UIButton.buttonWithType(UIButtonTypeRoundedRect), :day_btn)
            @week_btn = subview(UIButton.buttonWithType(UIButtonTypeRoundedRect), :week_btn)
            @month_btn = subview(UIButton.buttonWithType(UIButtonTypeRoundedRect), :month_btn)
          end

          @day_btn.when_tapped do
            if App::Persistence[:last_check_in_date] == NSDate.today
              screen = mm_drawerController.send(:day_screen)
            else
              screen = mm_drawerController.send(:check_in_screen)
            end
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

        @day_label = view.viewWithTag TAGS[:day_label]

        @small_step_name_button = view.viewWithTag TAGS[:small_step_name_button]
        @small_step_name_button.sizeToFit

        @chevron = view.viewWithTag TAGS[:chevron]

        @no_button = view.viewWithTag TAGS[:no_button]
        @no_button.addTarget(self, action: "answer_no", forControlEvents: UIControlEventTouchUpInside)

        @yes_button = view.viewWithTag TAGS[:yes_button]
        @yes_button.addTarget(self, action: "answer_yes", forControlEvents: UIControlEventTouchUpInside)

        @excuse_button = view.viewWithTag TAGS[:excuse_button]
        @excuse_button.addTarget(self, action: "open_complex_check_in", forControlEvents: UIControlEventTouchUpInside)

        @date = self.date || NSDate.today
        date_string_for_label = @date.string_with_format('MMM d')

        @is_update = self.is_update || false

        @comments = self.comments || nil

        if @is_update
          @cancel_button = view.viewWithTag TAGS[:cancel_button]
          @cancel_button.alpha = 1
          @cancel_button.addTarget(self, action: "cancel_action", forControlEvents: UIControlEventTouchUpInside)
        end

        @day_label.text = date_string_for_label
        Week.get_small_steps(@date, @is_update) do |success, week|
          if success
            @week = week

            small_steps = week[:small_steps]
            today_or_yesterday = (date == NSDate.today) ? 'today': 'yesterday'
          
            if small_steps.count == 1
              small_step = small_steps.first
              small_step_name = small_step['name']
              @small_step_name_button.setTitle("Did you #{ small_step_name.downcase } #{ today_or_yesterday }?", forState: UIControlStateNormal)
              if small_step[:note].to_s != '' || small_step[:attachments].any?
                @small_step_name_button.addTarget(self, action: "open_step", forControlEvents: UIControlEventTouchUpInside)
                @chevron.addTarget(self, action: "open_step", forControlEvents: UIControlEventTouchUpInside)
              else
                @chevron.alpha = 0
              end
            elsif small_steps.count > 1
              @small_step_name_button.setTitle("Did you do your steps #{ today_or_yesterday }?", forState: UIControlStateNormal)
              @small_step_name_button.addTarget(self, action: "open_check_in_details", forControlEvents: UIControlEventTouchUpInside)
              @chevron.addTarget(self, action: "open_check_in_details", forControlEvents: UIControlEventTouchUpInside)
            else
              @small_step_name_button.setTitle("No steps for #{ today_or_yesterday }.", forState: UIControlStateNormal)
            end
          else
            App.alert("There was an error.")
            NSLog("Date: #{ @date }: Error getting small steps.")
          end
        end
      end
    end

    def cancel_action
      screen = DayScreen.new(nav_bar: true, date: @date)
      mm_drawerController.centerViewController = screen
    end

    def answer_no
      do_answer(0)
    end

    def answer_yes
      do_answer(1)
    end

    def do_answer(status)

      if @week[:small_steps].count > 0

        data = {
          week_id: @week[:id],
          date: @date,
          status: status,
          small_steps: @week[:small_steps],
          comments: @comments
        }

        unless @is_update
          CheckIn.create(data) do |success|
            if success
              screen = mm_drawerController.send(:thank_you_screen)
              mm_drawerController.centerViewController = screen
              App::Persistence[:last_check_in_date] = NSDate.today
            else
              App.alert("There was an error")
              NSLog("Error creating check in")
            end
          end
        else
          check_in = @week[:check_in_id]

          CheckIn.update(data, check_in) do |success|
            if success
              screen = mm_drawerController.send(:thank_you_screen)
              mm_drawerController.centerViewController = screen
            else
              App.alert("There was an error")
              NSLog("Error updating check in")
            end
          end
        end
      end
    end

    def open_step
      @small_step = @week[:small_steps].first
      mm_drawerController.open StepScreen.new(nav_bar: true, step: @small_step)
    end

    def open_check_in_details
      screen = CheckInDetailsScreen.new(nav_bar: true, week: @week, date: @date, is_update: @is_update)
      mm_drawerController.open screen
      # screen = CheckInDetailsScreen.new(nav_bar: false, week: @week, date: @date, is_update: @is_update, comments: @week['check_in_comments'])
      # mm_drawerController.rightDrawerViewController = screen
      # mm_drawerController.toggleDrawerSide MMDrawerSideRight, animated:true, completion: nil
    end

    def open_complex_check_in
      screen = ComplexCheckInScreen.new(nav_bar: false, week: @week, date: @date, is_update: @is_update, comments: @week['check_in_comments'])
      mm_drawerController.rightDrawerViewController = screen
      mm_drawerController.toggleDrawerSide MMDrawerSideRight, animated:true, completion: nil
    end

    def open_excuses # Not being used for now
      screen = ExcuseScreen.new(nav_bar: false, date: @date, week: @week, is_update: @is_update)
      mm_drawerController.rightDrawerViewController = screen
      mm_drawerController.toggleDrawerSide MMDrawerSideRight, animated:true, completion: nil
    end

    def open_single_check_in_details
      screen = SingleCheckInDetailsScreen.new(nav_bar: false, small_step: @week['small_steps'].first, date: @date, is_update: @is_update, comments: @week['check_in_comments'])
      mm_drawerController.rightDrawerViewController = screen
      mm_drawerController.toggleDrawerSide MMDrawerSideRight, animated:true, completion: nil
    end
  end
end
