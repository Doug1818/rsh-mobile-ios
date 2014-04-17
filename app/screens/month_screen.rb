module Screen
  class MonthScreen < PM::Screen

    stylesheet :month_styles

    def on_load
      self.title = ''

      Week.get_weeks do |success, weeks|
        if success
          @data = weeks
          dictionary_data = {}
          @data.collect { |w| w.days }.flatten.collect { |day| dictionary_data[day[:full_date]] = day[:check_in_status].to_s }
          App::Persistence[:dictionary_data] = dictionary_data
          App::Persistence[:start_date] = dictionary_data.keys[0]
          NSLog(App::Persistence[:dictionary_data]["2014-02-11"])
          NSLog(App::Persistence[:start_date])
        else
          App.alert("Could not load data. Try signing out and back in.")
        end
      end
    end

    def will_appear
      super

      @view_is_set_up ||= begin
        mm_drawerController.title = title
        view.subviews.each &:removeFromSuperview

        layout(self.view, :main_view) do

          @calendar_view = subview(MNCalendarView.alloc.initWithFrame(self.view.bounds), :calendar)
          @calendar_view.selectedDate = NSDate.today
          @calendar_view.delegate = self

          @calendar_view.when_swiped do
            UIView.animateWithDuration(0.1,
              animations:lambda {
                screen = mm_drawerController.send(:week_screen)
                mm_drawerController.centerViewController = screen
              }
            )
          end

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

        # Add Observer to set up links
        notification_center = NSNotificationCenter.defaultCenter()
        notification_center.addObserver(self, selector:"send_to_day_screen:", name:"kCalendarViewDayTapped", object:nil)
      end
    end

    def send_to_day_screen(notification)
      info = notification.userInfo
      NSLog(info["date"])
      date_formatter = NSDateFormatter.alloc.init
      date_formatter.dateFormat = "yyyy-MM-dd"

      date = date_formatter.dateFromString info["date"]
      start_date = date_formatter.dateFromString App::Persistence[:start_date]

      # index = date - start_date

      # week  = @data
      # days  = week.collect {|w| w.days}.flatten
      # day   = days.flatten[0]
      # date_string  = day['date']
      
      # if active_cell_on_day(day)
        if date <= NSDate.today && date >= start_date
          screen = DayScreen.new(nav_bar: true, date: date)
          mm_drawerController.centerViewController = screen
        end
      # end
    end

    def active_cell_on_day(day)
      if day['is_future']
        false
      else
        day['needs_check_in'] or day['check_in_status']
      end
    end
  end
end
