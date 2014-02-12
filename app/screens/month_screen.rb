module Screen
  class MonthScreen < PM::Screen

    stylesheet :month_styles

    def on_load
      self.title = ''
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
      end
    end
  end
end
