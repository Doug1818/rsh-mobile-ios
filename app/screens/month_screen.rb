module Screen
  class MonthScreen < PM::Screen

    stylesheet :month_styles

    def on_load
      self.title = 'Month'
    end

    def will_appear
      super

      @view_is_set_up ||= begin
        mm_drawerController.title = title
        view.subviews.each &:removeFromSuperview

        layout(self.view, :main_view) do
          subview(UIView, :program_nav) do
            @day_btn = subview(UIButton.buttonWithType(UIButtonTypeRoundedRect), :day_btn)
            @week_btn = subview(UIButton.buttonWithType(UIButtonTypeRoundedRect), :week_btn)
            @month_btn = subview(UIButton.buttonWithType(UIButtonTypeRoundedRect), :month_btn)
          end

          @day_btn.when_tapped do
            App::Persistence[:selected_date] = NSDate.today
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
      end
    end
  end
end